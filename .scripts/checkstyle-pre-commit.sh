#!/bin/bash

# TODO
#  Check if checkstyle jar exists in .checkstyle already. download if not. same with google_checks.
#  then lint src/ or all of all

CHECKSTYLE_VERSION="https://github.com/checkstyle/checkstyle/releases/download/checkstyle-10.12.0/checkstyle-10.12.0-all.jar"

PRE_COMMIT_DIR=~/.cache/pre-commit/checkstyle
CHECKSTYLE_JAR="checkstyle.jar"
GOOGLE_CHECKS="google_checks.xml"
SUN_CHECKS="sun_checks.xml"
OUTPUT_FILE="${PRE_COMMIT_DIR}/output.txt"

STRICT=false
EXIT_CODE=0

while getopts c:s flag
do
    case "${flag}" in
        c) CONFIG_ARG=${OPTARG};;
        s) STRICT=true;;
        *) EXIT_CODE=1;;
    esac
done

if [ $EXIT_CODE != 0 ]
then
  echo "exit"
  exit $EXIT_CODE
fi


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

# switch to specify config to use.
# default to sun_checks.xml
case "${CONFIG_ARG}" in
  "google") CONFIG_ARG="${GOOGLE_CHECKS}";;
  "sun") CONFIG_ARG="${SUN_CHECKS}";;
  *) CONFIG_ARG="${SUN_CHECKS}";;

esac

CHECKSTYLE_CONFIG="${PRE_COMMIT_DIR}/${CONFIG_ARG}"

echo "running checkstyle using ${CONFIG_ARG} config"
LINT_RESULT=$(java -jar "${PRE_COMMIT_DIR}/${CHECKSTYLE_JAR}" -o "${OUTPUT_FILE}" -c "${CHECKSTYLE_CONFIG}" **/*.java)

ERRORS=0
while read line; do
# parse output lines
  if [[ "${line}" == '[ERROR]'* ]]
  then
    ERRORS=$((ERRORS + 1))
    echo "${line}"
  fi

  if [[ "${line}" == '[WARN]'* && $STRICT = true ]]
  then
    ERRORS=$((ERRORS + 1))
    echo "${line}"
  fi
done < "${OUTPUT_FILE}"

# if any errors set exit code to failing
if [ $ERRORS -gt 0 ]
then
  EXIT_CODE=1
fi

exit $EXIT_CODE