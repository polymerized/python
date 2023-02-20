#!/bin/bash
test
if ! command -v docker > /dev/null 2>&1; then
  printf "[polymerized] 'docker' command not found.\n"
  exit 1
fi

function run {
  docker run --mount type=bind,source="$(pwd)",target=/home/user/project --platform linux/amd64 --name polymerized-$1 --rm -it polymerized/$1
}

run "python"
