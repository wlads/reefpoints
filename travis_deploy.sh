#!/usr/bin/env bash

set -e

git config --global user.email "socko@dockyard.com"
git config --global user.name "sockothesock"


# This specifies the user who is associated to the GH_TOKEN
USER="sockothesock"

# sending output to /dev/null to prevent GH_TOKEN leak on error
git remote rm origin
git remote add origin https://${USER}:${GHTOKEN}@github.com/dockyard/reefpoints.git &> /dev/null


bundle exec rake publish

# Push build/posts.json to homeport.dockyard.com
bundle exec rake build
echo -e "Built\n"

scp build/posts.json temp_deploy@homeport.dockyard.com: -i reefpoints_deploy > status.txt
cat status.txt

echo -e "Done\n"
