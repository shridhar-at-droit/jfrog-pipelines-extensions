fluxcd_execute() {
  local imageName=$(find_step_configuration_value "imageName")
  if [ ! -z "$imageVersion" ] && [ ! -z "$imageName" ]; then
    local success=true
    local index=${step_configuration_imageName_len}
    cd deploy/overlays/${POD_ENV}
    for ((i = 0; i < ${index}; ++i)); do
      var="step_configuration_imageName_$i"
      value="${!var}=${step_configuration_dockerRegistry}:${imageVersion}"
      kustomize edit set image $value
    done
  else
    echo "imageName and imageVersion are required"
  fi
  $success
}
execute_command "fluxcd_execute"


