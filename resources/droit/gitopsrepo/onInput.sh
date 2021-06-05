fluxcd_input() {
  
    local repo=$(find_resource_variable "${1}" repo)
    local branch=$(find_resource_variable "${1}" branch)
    local resourcePath=$(find_resource_variable "${1}" resourcePath)
    local githubtokenvar="res_${1}_gitProvider_token"
    local githubtoken="${!githubtokenvar}"

    mkdir -p  "${resourcePath}" && cd "${resourcePath}"
    ssh-keygen -q -t rsa -N '' -f ~/.ssh/jfrog_pipelines_rsa
    local KEY=$( cat ~/.ssh/jfrog_pipelines_rsa.pub )
    local gitapi_url="https://api.github.com/repos/droitfintech/${repo}/keys"
 
curl --silent --output key.json -X POST "${gitapi_url}" \
-H "Authorization: token ${githubtoken}" \
-d @- << EOF
  {
    "title": "droit-github-jfrog-pipeline",
    "key": "$KEY"
  }
EOF
    export ssh_key_id=$(jq .id key.json)
    eval $(ssh-agent -s) && ssh-add ~/.ssh/jfrog_pipelines_rsa
    git clone git@github.com:droitfintech/${repo}.git
    git config --global user.email "devops-at-droit@droitfintech.com"
    git config --global user.name "devops-at-droit"
    cd ${repo}
  
}
execute_command "fluxcd_input %%context.resourceName%%"