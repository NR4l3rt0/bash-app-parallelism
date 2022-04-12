#!/bin/bash

source ./func_update_3x_4x.lib

#set -xv

work_in_progress=0
max_concurrency=3

check_file_existence $1

# It takes the action to do (var ACTION is a function name)
[[ $? == 0 ]] && echo -e "\nWhat would you like to do to the projects in $1?\n" && ACTION=$( menu_prompt $1 )

# We will take advantage of the setup step and if the full execution is going to take place, coverter tool will be downloaded once and copied to different directories
[[ ${ACTION} == "full_execution_wrapper" ]] && set_converter_tool

# It will iterate over the file to get each project and will pass the variables to the main program once an action has been determined
if [[ ! -z ${ACTION}  ]]; then
    while read -r project token user; do 

        echo "WIP: ${work_in_progress}. Max: ${max_concurrency}"

        # WIP max is max_concurrency. When reached, the program waits until the previous jobs have finished
        if (( ${work_in_progress}%${max_concurrency} == 0 )); then
            echo -e "\nMax WIP reached, waiting until previous jobs finish"
            wait;  
            work_in_progress=0
        fi

        check_context_project_and_call $project $token $user $ACTION 
        # We add one each time a job is launched successfully
        [[ $? == 0 ]] && ((work_in_progress++));
    done < <( cat $1 )

    echo -e "\nWaiting for the last jobs to finish"
    wait
else
    echo -e "\nError in $0, no action has been selected."
fi

echo -e "\nEnd of script"


