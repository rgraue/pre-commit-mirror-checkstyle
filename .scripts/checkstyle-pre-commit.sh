#!/bin/bash

# TODO
#  Check if checkstyle jar exists in .checkstyle already. download if not. same with google_checks.
#  then lint src/ or all of all
set -o pipefail

CHECKSTYLE_VERSION="https://github.com/checkstyle/checkstyle/releases/download/checkstyle-10.12.0/checkstyle-10.12.0-all.jar"

PRE_COMMIT_DIR=~/.cache/pre-commit/checkstyle
CHECKSTYLE_JAR="checkstyle.jar"
GOOGLE_CHECKS="google_checks.xml"
SUN_CHECKS="sun_checks.xml"


if [ ! -d "${PRE_COMMIT_DIR}" ]
then
  echo "caching directory under: ${PRE_COMMIT_DIR}"
  mkdir "${PRE_COMMIT_DIR}"
fi

if [ ! -f "${PRE_COMMIT_DIR}/${CHECKSTYLE_JAR}" ]
then 
  echo "downloading checkstyle"
  curl -o "${PRE_COMMIT_DIR}/${CHECKSTYLE_JAR}" -LJO "${CHECKSTYLE_VERSION}"
fi

if [ ! -f "${PRE_COMMIT_DIR}/${GOOGLE_CHECKS}" ]
then
  echo "downloading google_checks config"
  curl -o "${PRE_COMMIT_DIR}/${GOOGLE_CHECKS}" https://raw.githubusercontent.com/checkstyle/checkstyle/master/src/main/resources/google_checks.xml
fi

if [ ! -f "${PRE_COMMIT_DIR}/${SUN_CHECKS}" ]
then
  echo "downloading sun_checks config"
  curl -o "${PRE_COMMIT_DIR}/${SUN_CHECKS}" https://raw.githubusercontent.com/checkstyle/checkstyle/master/src/main/resources/sun_checks.xml

fi

# TODO take argument to switch config or point to local custom config.
CONFIG="${PRE_COMMIT_DIR}/${SUN_CHECKS}"

echo "running checkstyle"
java -jar "${PRE_COMMIT_DIR}/${CHECKSTYLE_JAR}" -c "${CONFIG}" **/*.java

exit 1