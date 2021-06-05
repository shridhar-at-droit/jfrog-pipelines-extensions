fluxcd_complete() {
    local repo=$(find_resource_variable "${1}" branch)
    local githubtokenvar="res_${1}_gitProvider_token"
    local githubtoken="${!githubtokenvar}"
    local gitapi_url="https://api.github.com/repos/droitfintech/${repo}/keys/${ssh_key_id}"

    curl --silent -X DELETE "${gitapi_url}" \
    -H "Authorization: token ${githubtoken}" \
    -H "Accept: application/vnd.github.v3+json"
}

execute_command "fluxcd_complete $res_%%context.resourceName%%"