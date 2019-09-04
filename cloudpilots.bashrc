# CLOUDPILOTS bashrc config

parse_git_branch() {
    git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (git:\1)/'
}

PS1='\n\[\e[1;33m\]\u\[\e[1;31m\]@\[\e[1;32m\]${GCLOUD_PROJECT}\[\e[1;34m\] \w\[\e[1;${FGC}m\]$(parse_git_branch)\n\[\e[1;34m\]\[\e[0m\]\$ '
export GCLOUD_PROJECT=$(gcloud config get-value project 2>/dev/null)

if [[ -z "$GCLOUD_PROJECT" ]]; then
  echo
  echo "You have no GCP project set. Please select a GCP project"
  gcloud projects list | awk '{printf("%5d : %s\n", NR-1,$0)}'
  echo
  echo "What project should be set as default project?"
  echo "(use the position or the project id)"
  echo -n "your selection: "
  read GCLOUD_PROJECT
  re='^[0-9]+$'
  if [[ "$project_id" =~ $re ]]; then
    # number
    GCLOUD_PROJECT=$(gcloud projects list | sed "${project_id}q;d" | awk '{print $1}')
  fi
  export GCLOUD_PROJECT
  gcloud config set project "$GCLOUD_PROJECT"
fi

eval `cloudshell aliases`