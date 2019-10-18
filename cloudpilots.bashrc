# Custom bashrc config

parse_git_branch() {
  git_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
  if [ -n "$git_branch" ]; then
    echo -n " (git:${git_branch})"
  fi
}

select_gcp_project() {
  gcloud projects list | awk '{printf("%5d : %s\n", NR-1,$0)}'
  echo
  echo "What project should be set as default project?"
  echo "(use the position or the project id)"
  echo -n "your selection: "
  read GCLOUD_PROJECT
  re='^[0-9]+$'
  if [[ "$GCLOUD_PROJECT" =~ $re ]]; then
    # number
    GCLOUD_PROJECT=$(gcloud projects list | sed "${GCLOUD_PROJECT}q;d" | awk '{print $1}')
  fi
  export GCLOUD_PROJECT
  export PROJECT_ID=$GCLOUD_PROJECT
  gcloud config set project "$GCLOUD_PROJECT"
}

PS1='\n\[\e[1;33m\]\u\[\e[1;31m\]@\[\e[1;32m\]${GCLOUD_PROJECT}\[\e[1;34m\] \w\[\e[1;m\]$(parse_git_branch)\n\[\e[1;34m\]\[\e[0m\]\$ '
export GCLOUD_PROJECT=$(gcloud config get-value project 2>/dev/null)

if [[ -z "$GCLOUD_PROJECT" ]]; then
  echo
  echo "You have no GCP project set. Please select a GCP project"
  select_gcp_project
fi

eval `cloudshell aliases`
