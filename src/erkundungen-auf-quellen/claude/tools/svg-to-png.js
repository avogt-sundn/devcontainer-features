#!/usr/bin/env node
// Verwendung: node svg-to-png.js [--scale=N] <datei.svg> [weitere.svg ...]
// Erzeugt je ein PNG im selben Verzeichnis wie das SVG (datei.svg → datei.png).
// Standard-Skalierung: 2 (Retina/HiDPI).

'use strict';

const fs   = require('fs');
const path = require('path');

// --- Argumente --------------------------------------------------------------

const rawArgs = process.argv.slice(2);
if (rawArgs.length === 0) {
  console.error('Verwendung: node svg-to-png.js [--scale=N] <datei.svg> ...');
  process.exit(1);
}

const scaleFlag = rawArgs.find(a => a.startsWith('--scale='));
const scale     = scaleFlag ? parseFloat(scaleFlag.split('=')[1]) : 2;
const svgFiles  = rawArgs.filter(a => !a.startsWith('--'));

if (svgFiles.length === 0) {
  console.error('Keine SVG-Dateien angegeben.');
  process.exit(1);
}

// --- playwright-core --------------------------------------------------------

let chromium;
try {
  ({ chromium } = require('playwright-core'));
} catch {
  console.error(
    'playwright-core nicht gefunden.\n' +
    'Installieren: cd .claude/tools && npm install playwright-core'
  );
  process.exit(1);
}

// --- Chromium-Pfad ----------------------------------------------------------

function findChromium() {
  if (process.env.CHROMIUM_PATH && fs.existsSync(process.env.CHROMIUM_PATH)) {
    return process.env.CHROMIUM_PATH;
  }
  const msCache = path.join(process.env.HOME || '/root', '.cache', 'ms-playwright');
  if (fs.existsSync(msCache)) {
    const dir = fs.readdirSync(msCache).find(d => d.startsWith('chromium-'));
    if (dir) {
      const bin = path.join(msCache, dir, 'chrome-linux', 'chrome');
      if (fs.existsSync(bin)) return bin;
    }
  }
  return null;
}

// --- Hauptprogramm ----------------------------------------------------------

(async () => {
  const executablePath = findChromium();
  if (!executablePath) {
    console.error(
      'Chromium nicht gefunden.\n' +
      'Setze CHROMIUM_PATH oder installiere via: npx playwright install chromium'
    );
    process.exit(1);
  }

  const browser = await chromium.launch({
    executablePath,
    args: ['--no-sandbox', '--disable-setuid-sandbox'],
  });

  const context = await browser.newContext({ deviceScaleFactor: scale });
  const page    = await context.newPage();

  let ok = 0;
  let fail = 0;

  for (const svgFile of svgFiles) {
    const input  = path.resolve(svgFile);
    const output = input.replace(/\.svg$/i, '.png');

    if (!fs.existsSync(input)) {
      console.error(`Nicht gefunden: ${input}`);
      fail++;
      continue;
    }

    try {
      await page.goto(`file://${input}`);
      const svgEl = await page.$('svg');
      if (!svgEl) {
        console.error(`Kein <svg>-Element in: ${input}`);
        fail++;
        continue;
      }

      const box = await svgEl.boundingBox();
      await page.setViewportSize({
        width:  Math.ceil(box.width),
        height: Math.ceil(box.height),
      });
      await page.screenshot({ path: output });

      const pxW = Math.ceil(box.width  * scale);
      const pxH = Math.ceil(box.height * scale);
      console.log(`✓ ${path.relative(process.cwd(), output)} (${pxW}×${pxH}px @${scale}x)`);
      ok++;
    } catch (err) {
      console.error(`Fehler bei ${input}: ${err.message}`);
      fail++;
    }
  }

  await browser.close();

  if (fail > 0) {
    console.error(`${fail} Fehler, ${ok} erfolgreich.`);
    process.exit(1);
  }
})();
