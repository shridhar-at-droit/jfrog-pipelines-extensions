leinpublish_execute() {
  local success=true
  local index=${step_configuration_modules_len}
   echo "---> ${pipeline_name} - ${run_number}"
  jfrog rt use artifactory
  jfrog rt build-collect-env "${pipeline_name}" "${run_number}"
  for ((i = 0; i < ${index}; ++i)); do
    var="step_configuration_modules_$i"
    value="${!var}"
    echo "jfrog rt upload $PIPELINE_WORKSPACE/${value}/target/*.jar droit-jfrogpipelines"
  done
  jfrog rt bad "${pipeline_name}" "${run_number}" "~/.m2/repository/"
  jfrog rt build-publish "${pipeline_name}" "${run_number}"
  $success
}

execute_command "leinpublish_execute"