#!/bin/sh
# X-RAY the .git folder to check the BLOBS :D
# This scripts can be used to answer the question:
#   Does git really stores a new blob with the full copy
#   of a file every time the file is changed?
# 
# The script will:
# - create a new repository (every time using a new random folder name)
# - commit a text file (1MB)
# - make small change and commit it again
#
# While running the script the '.git/objects' folder
# is X-rayed to see the blobs and their files.

this_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source $this_dir/utils.sh

FILE_COUNTER=0
NEW_FILE=""

create_empty_file() {
   FILE_COUNTER=$((FILE_COUNTER+1))
   NEW_FILE="file$FILE_COUNTER"
   touch $repo_dir/$NEW_FILE
}

create_big_file() {
   FILE_COUNTER=$((FILE_COUNTER+1))
   NEW_FILE="file$FILE_COUNTER"
   base64 /dev/urandom | head -c 1000000 > $repo_dir/$NEW_FILE
}

print_blobs() {
   git cat-file --batch-check --batch-all-objects
}

print_blob_files() {
   find .git/objects/* -type f -exec du -smh {} \;
}

remove_repo_dir() {
   if [ ! -z "$repo_dir" ]
   then
      rm -rf $repo_dir
      if [ "$?" != 0 ]
      then
         log_nok "Could not remove '$repo_dir'!"
         exit 1
      else
         log_ok "Folder '$repo_dir' deleted!"
      fi
   fi
}

repo_tmp_dir_pattern="$this_dir/out/REPO_XXXXXXXXX"
repo_dir=$(mktemp -u -d $repo_tmp_dir_pattern)
mkdir -p $repo_dir

cd $repo_dir

log_info "Create repository under '$repo_dir' "
git init

log_info "Create and add a big file"
create_big_file
git add $NEW_FILE
log_info "One blob created for $NEW_FILE"
print_blobs
git commit -m "$NEW_FILE"
log_info "Some more blobs created after commiting $NEW_FILE"
print_blobs

log_info "Append a line to the file"
echo "I am a new small change" >> $NEW_FILE
git add $NEW_FILE
git commit -m "$NEW_FILE"

log_attention "Commiting a new small change to $NEW_FILE creates a new big blog :("
print_blobs
log_info "All files in '.git/objects' "
print_blob_files

log_info "Run the garbage collector: 'git gc' "
git gc


log_attention "Were the blob files really deleted?!?"
print_blob_files

log_attention "The blob files YES! The blobs NOT! The blobs are packed in the 'pack' files!"
print_blobs

log_info "Read more about Packfiles here: https://git-scm.com/book/en/v2/Git-Internals-Packfiles"

# Comment the next line if you want to keep the repository folder
remove_repo_dir
