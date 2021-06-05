sendSuccessSlackNotification() {
  local slackIntegrationName=$(get_integration_name --type "Slack")
  local resourcenName=$(get_resource_name --type GitRepo --operation IN)
  local slackChannel=$(find_step_configuration_value "slackChannel")
  
  if [  -z "$slackIntegrationName" ] || [ ! -z "$resourcenName" ] || [ ! -z "$slackChannel" ]; then
    local notifyOnSuccess=$(find_step_configuration_value "notifyOnSuccess")
    if [ -z "$notifyOnSuccess" ]; then
      notifyOnSuccess=false
    fi
    if [ "$notifyOnSuccess" == "true" ]; then
      echo "Sending success notification"
      update_commit_status ${resourcenName} --message "Succeeded :-)" --context "$pipeline_name:$run_number"
      send_notification slack --recipient "${slackChannel}" --text "Succeeded $pipeline_name:$run_number"
    else
      echo "notifyOnSuccess is set to false, skipping notification"
    fi
  else
    echo "Slack integration  and SlackChannel and Resource type GitRepo are required, skipping notification"
  fi
}

execute_command sendSuccessSlackNotification