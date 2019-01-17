#!/bin/sh
# Add a short description

this_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source $this_dir/utils.sh

repo_tmp_dir_pattern="$this_dir/out/REPO_XXXXXXXXX"
repo_dir=$(mktemp -u -d $repo_tmp_dir_pattern)
mkdir -p $repo_dir

cd $repo_dir

log_info "Create new repository under '$repo_dir' "
git init
