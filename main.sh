#!/usr/bin/bash 

## Set this ones if run individually and comment set_context_project

#BI_USER="identity of the user that runs the script and have permission in the company"
#TOKEN="project's token"
#PROJECT="name of the bitbucket project"
#PROJECT_LOGFILE="${PROJECT}_log.csv"
#API_URL="https://domain.com/rest/api/1.0/projects/${PROJECT}"
#ACTION="function name to call"
#CONTEXT_DIR=$PWD


# Import library
source ./func_update_3x_4x.lib

# If the context was created, then change stdout and stderr to the appropiate logfile, but also it's possible to write to the console with fd 3
touch "$1"_general_main.log
exec 3>&1 1>>"$1"_general_main.log 2>&1

echo "Launching main.sh in $1" | tee /dev/fd/3

set_context_project $1 $2 $3 $4

[[ $? == 0 ]] && echo -e "\nWorking in project: $1; Action: ${ACTION}" 

# If it's a full execution, this prevents the existing logfile to be overwritten
[[ ${ACTION} == "full_execution_wrapper" ]] && check_repos_synchronicity_and_adjust 


# Execute the action previous selected in this context
${ACTION} 

echo "Finishing main.sh in $1" | tee /dev/fd/3
exec 3>&-
