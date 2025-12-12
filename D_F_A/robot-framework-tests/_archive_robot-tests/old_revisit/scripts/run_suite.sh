#!/usr/bin/env bash
set -e

#CMD="robot --console verbose --outputdir /reports /suites"
CMD="python3 /scripts/selenium-headless.py"

echo ${CMD}

``${CMD}``