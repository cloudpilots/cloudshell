# Custom bashrc config

parse_git_branch() {
  git_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
  if [ -n "$git_branch" ]; then
    echo -n " (git:${git_branch})"
  fi
}

select_gcp_project() {
  GCLOUD_ALL_PROJECTS=$(gcloud projects list)
  echo "$GCLOUD_ALL_PROJECTS" | awk '{printf("%5d : %s\n", NR-1,$0)}'
  echo
  echo "What project should be set as default project?"
  echo "(use the position or the project id)"
  echo -n "your selection: "
  read GCLOUD_PROJECT
  re='^[0-9]+$'
  if [[ "$GCLOUD_PROJECT" =~ $re ]]; then
    # number
    GCLOUD_PROJECT=$(echo "$GCLOUD_ALL_PROJECTS" | sed "$(($GCLOUD_PROJECT + 1))q;d" | awk '{print $1}')
  fi
  export GCLOUD_PROJECT
  gcloud config set project "$GCLOUD_PROJECT"
}

PS1='\n\[\e[1;33m\]\u\[\e[1;31m\]@\[\e[1;32m\]${GCLOUD_PROJECT}\[\e[1;34m\] \w\[\e[1;m\]$(parse_git_branch)\n\[\e[1;34m\]\[\e[0m\]\$ '
# export GCLOUD_PROJECT=$(gcloud config get-value project 2>/dev/null)
exort GCLOUD_PROJECT=$DEVSHELL_PROJECT_ID
export PROJECT_ID=$GCLOUD_PROJECT

if [[ -z "$GCLOUD_PROJECT" ]]; then
  echo
  echo "You have no GCP project set. Please select a GCP project"
  select_gcp_project
fi

eval $(cloudshell aliases)

# Bash aliases
#

alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'
alias tf='terraform'
alias tfi='terraform init'
alias tfp='terraform plan -out tfplan'
alias tfa='terraform apply'
alias k='kubectl'
alias kg='kubectl get'
alias kgp='kubectl get pod'
alias kgd='kubectl get deployment'
alias kgs='kubectl get service'
alias kgi='kubectl get ingress'
alias kd='kubectl describe'
alias ka='kubectl apply'
alias kdel='kubectl delete'
