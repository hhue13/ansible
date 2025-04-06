#!/usr/bin/env bash
set -ex

__baseDir=$1
__pod=$2
__backupFilePattern=$3
__retentionPeriod=$4

mkdir -p ${__baseDir}/${__pod}

__count=$(ls -latr ${__backupFilePattern} | wc -l)
if [[ ${__count} -ne 0 ]] ; then
  mv ${__backupFilePattern} ${__baseDir}/${__pod}
else
  echo "No files to move"
fi

echo "Files before house-keeping ..."
ls -latr ${__baseDir}/${__pod}

find ${__baseDir} /${__pod} -name $(basename ${__backupFilePattern}) -mtime +${__retentionPeriod} -exec rm -rf {} \;

echo "Files after house-keeping ..."
ls -latr ${__baseDir}/${__pod}


exit 0