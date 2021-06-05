
init_execute() {
  local success=true 
  local genericIntegrationName=$(get_integration_name --type "Generic Integration")
  local resourcenName=$(get_resource_name --type GitRepo --operation IN)
  local commitSHA=$(find_resource_variable "${resourcenName}" commitSha)
  local resourcePath=$(find_resource_variable "${resourcenName}" resourcePath)
  local isPullRequest=$( find_resource_variable "${resourcenName}" isPullRequest)
  local branchName=$( find_resource_variable "${resourcenName}" branchName)
  local slackIntegrationName=$(get_integration_name --type "Slack")
  local slackChannel=$(find_step_configuration_value "slackChannel")


  leinPasswordNameVar="int_${genericIntegrationName}_password"
  leinUsernameNameVar="int_${genericIntegrationName}_username"

  add_run_variables LEIN_PASSWORD="${!leinPasswordNameVar}"  LEIN_USERNAME="${!leinUsernameNameVar}"
  add_run_variables Job_Link=$(echo "<${step_url}|${pipeline_name##*/}[${run_number}]>") 
  cd $resourcePath &&  add_run_variables imageVersion="${commitSHA}"
  add_run_variables PIPELINE_WORKSPACE=${resourcePath} init_stepid="${step_id}"
  add_run_variables resourcenName=${resourcenName} isPullRequest="${isPullRequest}" branchName="${branchName}"
  add_run_variables slackIntegrationName=${slackIntegrationName} slackChannel="${slackChannel}"
  printenv
  $success
}
execute_command "init_execute"