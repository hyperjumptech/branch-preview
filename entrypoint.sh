#!/bin/bash

echo "Starting action"

eval $(ssh-agent -s)

echo "Setting up SSH"
mkdir -p ~/.ssh
chmod 700 ~/.ssh
echo -e "$DOKKU_KEY" > ~/.ssh/id_rsa
chmod 600 ~/.ssh/id_rsa
ssh-keyscan -t rsa "$HOST" >> ~/.ssh/known_hosts

cd "$GITHUB_WORKSPACE"

DEFAULT_BRANCH=${DEFAULT_BRANCH:-'master'}
CURRENT_BRANCH=`git rev-parse --abbrev-ref HEAD`

if [[ $CURRENT_BRANCH == $DEFAULT_BRANCH && -n $DOMAIN ]]; then
  APP_NAME=$DOMAIN
else
  APP_NAME=${CURRENT_BRANCH/\//-}
fi

echo "Checking if app exists"
ssh "dokku@$HOST" apps:exists $APP_NAME

if [[ $? != 0 ]]; then
  echo "The app does not exist yet, creating the app"
  ssh "dokku@$HOST" apps:create $APP_NAME
fi

echo "Deploying to host"
git fetch --unshallow
git remote add $APP_NAME "dokku@$HOST:$APP_NAME"
git push -f $APP_NAME "$CURRENT_BRANCH:master"
