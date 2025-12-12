#!/usr/bin/env bash

docker run --rm \
           --privileged \
           --net=host \
           -v "c:\\Projects\\Robot-Framework-Tests\\output":/output \
           -v "c:\\Projects\\Robot-Framework-Tests\\scripts":/scripts \
           -v "c:\\Projects\\Robot-Framework-Tests\\reports":/reports \
           -v "c:\\Projects\\Robot-Framework-Tests\\suites":/suites \
           --security-opt seccomp:unconfined \
           --shm-size "2G" \
           d/robotframework:18.04