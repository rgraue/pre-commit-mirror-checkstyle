#!/bin/bash

# TODO
#  Check if checkstyle jar exists in .checkstyle already. download if not. same with google_checks.
#  then lint src/ or all of all

# if [ dir does not exists ]
# then
#   mkdir .checkstyle
# fi
# if [ jar does not exist ]
# then
#   curl checkstyle
# fi
# if [ xml does not exist ]
# then
#   cp xml or.... curl it
# fi
#

# echo "Downloading checkstyle 10.12.0"
# curl -o ./.checkstyle/ -LJO https://github.com/checkstyle/checkstyle/releases/download/checkstyle-10.12.0/checkstyle-10.12.0-all.jar

echo "running linting command"
java -jar .checkstyle/checkstyle-10.12.0-all.jar -c .checkstyle/google_checks.xml **/*.java
