#!/usr/bin/env bash

git rev-parse --show-toplevel >/dev/null 2>&1

if ! git rev-parse --show-toplevel >/dev/null 2>&1; then
  echo "error: Not in a git repo."
  exit 1
fi

filename=$1
start_line=$2
end_line=$3

git_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
git_branch_in_url=$(echo "$git_branch" | sed 's/\//%2F/g')
git_remote_origin_url=$(git config --get remote.origin.url)
git_remote_url_unfinished=$(sed -s "s/^ssh/http/; s/git@//; s/.git$//; s/\(git\(hu\|la\)b\.com\):/\\1\//;" <<< "$git_remote_origin_url")
if [[ $git_remote_origin_url =~ github\.com ]]; then
  provider="github"
elif [[ $git_remote_origin_url =~ gitlab\.com ]]; then
  provider="gitlab"
else
  echo "error: Unknown provider service."
  exit 1
fi
git_remote_url="https://$(dirname "$git_remote_url_unfinished")/$(basename "$git_remote_url_unfinished")"

if [ -f "$filename" ]; then
  rel_filename=$(realpath -s --relative-to="$(git rev-parse --show-toplevel)" "$filename")
else # No filename supplied.
  if [[ $git_branch == "main" || $git_branch == "master" ]]; then
    echo "$git_remote_url"
    exit 0
  else
    echo "$git_remote_url/tree/$git_branch_in_url"
    exit 0
  fi
fi

if [[ $provider == "github" ]]; then
  url="$git_remote_url/blob/$git_branch/$rel_filename"
elif [[ $provider == "gitlab" ]]; then
  url="$git_remote_url/-/blob/$git_branch/$rel_filename"
fi

file_ext="${filename##*.}"
if [[ $file_ext == "md" || $file_ext == "org" ]]; then
  url="${url}?plain=1"
fi

if [[ -z $start_line ]]; then
  # No line numbers provided.
  : # nop
elif [[ -z $end_line ]]; then
  # Only start line number provided.
  url="$url#L$start_line"
else
  # Both start and end line numbers provided.
  if [[ $provider == "github" ]]; then
    url="$url#L$start_line-L$end_line"
  elif [[ $provider == "gitlab" ]]; then
    url="$url#L$start_line-$end_line"
  fi
fi

if command -v xsel &> /dev/null; then
  xsel -ib <<< "$url"
fi

echo "$url"
