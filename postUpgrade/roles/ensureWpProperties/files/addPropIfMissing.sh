#!/usr/bin/env bash
propFile=${1}
propKey=${2}
propVal=${3}

grep -E "^${propKey}=" ${propFile}
rc=$?
if [[ ${rc} -eq 0 ]]; then
  sed -i "s#^${propKey}=.*#${propKey}=${propVal}#g" ${propFile}
else
  echo "${propKey}=${propVal}" >> ${propFile}
fi
