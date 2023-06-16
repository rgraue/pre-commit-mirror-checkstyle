#!/bin/bash

echo "Downloading checkstyle 10.12.0"
curl -LJO https://github.com/checkstyle/checkstyle/releases/download/checkstyle-10.12.0/checkstyle-10.12.0-all.jar

echo "running linting command"
java -jar checkstyle-10.12.0-all.jar -c ../google_checks.xml ./
