sendFailureSlackNotification() { 
  local slackIntegrationName=$(get_integration_name --type "Slack")
  local resourcenName=$(get_resource_name --type GitRepo --operation IN)
  local slackChannel=$(find_step_configuration_value "slackChannel")

  if [ ! -z "$slackIntegrationName" ] && [ ! -z "$resourcenName" ] && [ ! -z "$slackChannel" ]; then
    local notifyOnFailure=$(find_step_configuration_value "notifyOnFailure")
    if [ -z "$notifyOnFailure" ]; then
      notifyOnFailure=true
    fi
    if [ "$notifyOnFailure" == "true" ]; then
      echo "Sending failure notification"
      update_commit_status "${resourcenName}" --message "Failed!" --context "$pipeline_name:$run_number"
      send_notification slack --color "#FF0000" --text " :hammer::poop:Failed $Job_Link" --recipient "${slackChannel}"
    else
      echo "notifyOnFailure is set to false"
    fi
  else
    echo "Slack integration  and SlackChannel and Resource type GitRepo are required, skipping notification"
  fi
}
execute_command sendFailureSlackNotification
 