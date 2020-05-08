#!/bin/bash -l

# project-key = $1
# project-name = $2
# organization = $3
# version = $4
# cpd-exclusions = $5
# opencover-report-paths = $6
# url = $7
# solution-path = $8
# pr-repository=$9
# pr-branch=$10
# pr-key=$11

set -eu

begin_cmd="/dotnet-sonarscanner begin \\
    /k:\"${1}\" \\
    /n:\"${2}\" \\
    /o:\"${3}\" \\
    /d:sonar.host.url=\"${7}\" \\
    /version:\"${4}\" \\
    /d:sonar.login=\"${SONAR_TOKEN:?Please set the SONAR_TOKEN environment variable.}\""

if [ -n "$6" ]
then
    begin_cmd="$begin_cmd /d:sonar.cs.opencover.reportsPaths=\"${6}\""
fi

if [ -n "$5" ]
then
    begin_cmd="$begin_cmd /d:sonar.cpd.exclusions=\"${5}\""
fi

if [ -n "$11" ]
then
    begin_cmd="$begin_cmd /d:sonar.pullrequest.github.repository=\"${9}\" \\
    /d:sonar.pullrequest.github.branch=\"${10}\" \\
    /d:sonar.pullrequest.github.key=\"${11}\""
fi


sh -c "dotnet build -c Release $8"
sh -c "dotnet-sonarscanner end /d:sonar.login=\"${SONAR_TOKEN}\""