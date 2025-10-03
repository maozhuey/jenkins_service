export SSH_AUTH_SOCK=/tmp/ssh-agent.sock
ssh-agent -a /tmp/ssh-agent.sock > /dev/null 2>&1 &
ssh-add /var/jenkins_home/.ssh/id_rsa > /dev/null 2>&1
export GIT_SSH_COMMAND="ssh -i /var/jenkins_home/.ssh/id_rsa -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"
