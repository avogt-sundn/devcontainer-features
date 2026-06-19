#!/usr/bin/env node
// Verwendung: node domain-to-pdf.js <eingabe.md> [ausgabe.pdf]
// Erzeugt ein A4-PDF aus einer DOMAIN.md (oder beliebiger .md-Datei).
// SVG-Einbettungen (![Titel](datei.svg)) werden inline aufgelöst.

const fs = require('fs');
const path = require('path');
const { execFileSync } = require('child_process');

const CHROME = '/ms-playwright/chromium-1208/chrome-linux/chrome';

const inputArg = process.argv[2];
if (!inputArg) {
  console.error('Verwendung: node domain-to-pdf.js <eingabe.md> [ausgabe.pdf]');
  process.exit(1);
}

const inputPath = path.resolve(inputArg);
const inputDir  = path.dirname(inputPath);
const stem      = path.basename(inputPath, '.md');
const pdfPath   = process.argv[3]
  ? path.resolve(process.argv[3])
  : path.join(inputDir, stem + '.pdf');

const md = fs.readFileSync(inputPath, 'utf8');

function mdToHtml(text) {
  const lines = text.split('\n');
  const out = [];
  let inTable = false;
  let inList = false;
  let tableHeaderDone = false;

  for (let i = 0; i < lines.length; i++) {
    let line = lines[i];

    if (line.startsWith('# '))  { closeList(); closeTable(); out.push(`<h1>${esc(line.slice(2))}</h1>`); continue; }
    if (line.startsWith('## ')) { closeList(); closeTable(); out.push(`<h2>${esc(line.slice(3))}</h2>`); continue; }
    if (line.startsWith('### ')){ closeList(); closeTable(); out.push(`<h3>${esc(line.slice(4))}</h3>`); continue; }

    // Bild — SVG inline einbetten, andere Formate überspringen
    const imgMatch = line.match(/!\[.*?\]\((.+?)\)/);
    if (imgMatch) {
      closeList(); closeTable();
      const imgFile = imgMatch[1];
      if (imgFile.endsWith('.svg')) {
        const svgPath = path.resolve(inputDir, imgFile);
        if (fs.existsSync(svgPath)) {
          out.push('<div class="svg-container">' + fs.readFileSync(svgPath, 'utf8') + '</div>');
        } else {
          out.push(`<p class="missing-img">[Bild nicht gefunden: ${esc(imgFile)}]</p>`);
        }
      }
      continue;
    }

    if (line.startsWith('|')) {
      if (!inTable) { inTable = true; tableHeaderDone = false; out.push('<table>'); }
      if (line.match(/^\|[-| ]+\|$/)) { if (!tableHeaderDone) tableHeaderDone = true; continue; }
      const cells = line.split('|').filter((_, i2, a) => i2 > 0 && i2 < a.length - 1);
      const tag = tableHeaderDone ? 'td' : 'th';
      out.push('<tr>' + cells.map(c => `<${tag}>${inline(c.trim())}</${tag}>`).join('') + '</tr>');
      if (!tableHeaderDone) tableHeaderDone = true;
      continue;
    }

    if (line.match(/^- /)) {
      if (!inList) { closeTable(); inList = true; out.push('<ul>'); }
      out.push(`<li>${inline(line.slice(2))}</li>`);
      continue;
    }

    if (line.trim() === '') { closeList(); closeTable(); out.push('<p class="spacer"></p>'); continue; }

    if (line.startsWith('```')) {
      closeList(); closeTable();
      const codeLines = [];
      i++;
      while (i < lines.length && !lines[i].startsWith('```')) { codeLines.push(esc(lines[i])); i++; }
      out.push(`<pre class="code">${codeLines.join('\n')}</pre>`);
      continue;
    }

    closeList(); closeTable();
    out.push(`<p>${inline(line)}</p>`);
  }

  closeList(); closeTable();
  return out.join('\n');

  function closeList()  { if (inList)  { inList  = false; out.push('</ul>');    } }
  function closeTable() { if (inTable) { inTable = false; out.push('</table>'); } }
  function esc(s) { return s.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;'); }
  function inline(s) {
    s = s.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;');
    s = s.replace(/\*\*\*(.+?)\*\*\*/g, '<strong><em>$1</em></strong>');
    s = s.replace(/\*\*(.+?)\*\*/g, '<strong>$1</strong>');
    s = s.replace(/\*(.+?)\*/g, '<em>$1</em>');
    s = s.replace(/`([^`]+)`/g, '<code>$1</code>');
    s = s.replace(/\[([^\]]+)\]\(([^)]+)\)/g, '<a href="$2">$1</a>');
    return s;
  }
}

const body = mdToHtml(md);

const html = `<!DOCTYPE html>
<html lang="de">
<head>
<meta charset="utf-8">
<title>${stem}</title>
<style>
  * { box-sizing: border-box; }
  body {
    font-family: -apple-system, 'Segoe UI', Arial, sans-serif;
    font-size: 9pt;
    color: #222;
    margin: 0;
    padding: 0;
  }
  .page {
    max-width: 900px;
    margin: 0 auto;
    padding: 28mm 20mm 20mm 20mm;
  }
  h1 { font-size: 16pt; color: #005f73; border-bottom: 2px solid #005f73; padding-bottom: 6px; margin-top: 0; }
  h2 { font-size: 12pt; color: #007a99; border-bottom: 1px solid #c0dde6; padding-bottom: 4px; margin-top: 2em; }
  h3 { font-size: 10pt; color: #005f73; margin-top: 1.5em; }
  p  { margin: 0.4em 0; line-height: 1.55; }
  p.spacer { margin: 0.3em 0; }
  p.missing-img { color: #c0392b; font-style: italic; }
  ul { margin: 0.3em 0 0.3em 1.4em; padding: 0; }
  li { margin: 0.25em 0; line-height: 1.5; }
  code { font-family: 'Cascadia Code','Courier New',monospace; font-size: 7.5pt; background: #eef6f8; padding: 1px 4px; border-radius: 3px; }
  pre.code { font-family: 'Cascadia Code','Courier New',monospace; font-size: 7pt; background: #f4f8fb; border: 1px solid #c0dde6; border-radius: 4px; padding: 10px 14px; overflow-x: auto; white-space: pre-wrap; margin: 0.6em 0; }
  table { border-collapse: collapse; width: 100%; margin: 0.6em 0; font-size: 8.5pt; }
  th { background: #005f73; color: #fff; padding: 6px 8px; text-align: left; }
  td { padding: 5px 8px; border: 1px solid #c0dde6; vertical-align: top; }
  tr:nth-child(even) td { background: #f4f8fb; }
  .svg-container { margin: 1.2em 0; page-break-inside: avoid; }
  .svg-container svg { width: 100%; height: auto; display: block; }
  a { color: #007a99; text-decoration: none; }
  @media print {
    body { -webkit-print-color-adjust: exact; print-color-adjust: exact; }
    h2 { page-break-after: avoid; }
    .svg-container { page-break-inside: avoid; }
    table { page-break-inside: auto; }
    tr { page-break-inside: avoid; }
  }
</style>
</head>
<body>
<div class="page">
${body}
</div>
</body>
</html>`;

const htmlPath = '/tmp/domain-to-pdf-tmp.html';
fs.writeFileSync(htmlPath, html, 'utf8');

execFileSync(CHROME, [
  '--headless=new',
  '--no-sandbox',
  '--disable-gpu',
  '--disable-dev-shm-usage',
  '--run-all-compositor-stages-before-draw',
  `--print-to-pdf=${pdfPath}`,
  '--print-to-pdf-no-header',
  '--window-size=1200,1600',
  `file://${htmlPath}`
], { stdio: 'pipe' });

console.log(pdfPath);
