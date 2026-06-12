#!/bin/bash
set -e
. dev-container-features-test-lib

check "ping available" which ping
check "dig available" which dig
check "file available" which file
check "ab available" which ab
check "http (httpie) available" which http
check "telnet available" which telnet

reportResults
