#!/usr/bin/env bash

docker run --rm \
           --privileged \
           -e PYTHONUNBUFFERED=0 \
           -p 4444:4444 \
           -v "c:\\Projects\\Robot-Framework-Tests\\scripts":/scripts \
           -v "c:\\Projects\\Robot-Framework-Tests\\reports":/reports \
           --security-opt seccomp:unconfined \
           --shm-size "2G" \
           d/robotframework:18.04