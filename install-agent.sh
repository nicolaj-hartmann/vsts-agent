rm -rf /azp/agent
mkdir /azp/agent
cd /azp/agent

export AGENT_ALLOW_RUNASROOT="1"

cleanup() {
  if [ -e config.sh ]; then
    print_header "Cleanup. Removing Azure Pipelines agent..."

    ./config.sh remove --unattended \
      --auth PAT \
      --token $(cat "$AZP_TOKEN_FILE")
  fi
}

print_header() {
  lightcyan='\033[1;36m'
  nocolor='\033[0m'
  echo -e "${lightcyan}$1${nocolor}"
}

# Let the agent ignore the token env variables
export VSO_AGENT_IGNORE=AZP_TOKEN,AZP_TOKEN_FILE

print_header "1. Downloading and installing Azure Pipelines agent..."


AZP_AGENTPACKAGE_URL='https://vstsagentpackage.azureedge.net/agent/2.153.2/vsts-agent-linux-x64-2.153.2.tar.gz'

curl -LsS $AZP_AGENTPACKAGE_URL | tar -xz & wait $!
