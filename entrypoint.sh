#!/bin/bash -l

# project-key = $1
# project-name = $2
# organization = $3
# cpd-exclusions = $4
# opencover-report-paths = $5
# url = $6
# solution-path = $7
# pr-key=$8

set -eu

begin_cmd="/dotnet-sonarscanner begin \\
    /k:\"${1}\" \\
    /n:\"${2}\" \\
    /o:\"${3}\" \\
    /d:sonar.host.url=\"${6}\" \\
    /version:\"${GITHUB_RUN_NUMBER}\" \\
    /d:sonar.login=\"${SONAR_TOKEN:?Please set the SONAR_TOKEN environment variable.}\""

if [ -n "$5" ]
then
    begin_cmd="$begin_cmd /d:sonar.cs.opencover.reportsPaths=\"${5}\""
fi

if [ -n "$4" ]
then
    begin_cmd="$begin_cmd /d:sonar.cpd.exclusions=\"${4}\""
fi

if [ -n "$8" ]
then
    begin_cmd="$begin_cmd /d:sonar.pullrequest.github.repository=\"${GITHUB_REPOSITORY}\" \\
    /d:sonar.pullrequest.github.branch=\"${GITHUB_REF#refs/heads/}\" \\
    /d:sonar.pullrequest.github.key=\"${8}\""
fi


sh -c "dotnet build -c Release $7"
sh -c "dotnet-sonarscanner end /d:sonar.login=\"${SONAR_TOKEN}\""