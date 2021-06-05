leingen_execute(){
  local success=true
  local index=${step_configuration_leinBuildCommand_len}
  local module=$(find_step_configuration_value "module")

  cd ${PIPELINE_WORKSPACE}/${module}
  for ((i = 0; i < ${index}; ++i)); do
    var="step_configuration_leinBuildCommand_$i"
    value="${!var}"
    eval "$value"
  done

  var="step_configuration_leinDeployCommand"
  value="${!var}"
  if ! $isPullRequest ; then 
    if [ $branchName == "master" ] || [ $branchName ==  "main" ]; then
     eval "$value"
    else
     echo "skipping ${value} as this is not master/main branch"
    fi
  else
   echo "skipping ${value} as this is not master branch"
  fi
  $success
}

execute_command "leingen_execute"