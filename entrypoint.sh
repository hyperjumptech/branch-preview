#!/bin/bash

echo "Starting action"

HOST=$INPUT_HOST
DOMAIN_NAME=$INPUT_DOMAIN_NAME
GITHUB_TOKEN=$INPUT_GITHUB_TOKEN

eval $(ssh-agent -s)

echo "Setting up SSH"
mkdir -p ~/.ssh
chmod 700 ~/.ssh
echo -e "$INPUT_PRIVATE_KEY" > ~/.ssh/id_rsa
chmod 600 ~/.ssh/id_rsa
ssh-keyscan -t rsa "$HOST" >> ~/.ssh/known_hosts

cat ~/.ssh/id_rsa

cd "$GITHUB_WORKSPACE"

DEFAULT_BRANCH=${DEFAULT_BRANCH:-'master'}
CURRENT_BRANCH=`git rev-parse --abbrev-ref HEAD`

if [[ $CURRENT_BRANCH == $DEFAULT_BRANCH && -n $DOMAIN_NAME ]]; then
  APP_NAME=$DOMAIN_NAME
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


