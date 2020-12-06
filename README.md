# Branch preview

Preview your latest changes. This GitHub Action deploys your branch to a Dokku instance and automatically assigns it a subdomain. This is an easy way to quickly push your latest changes and share your subdomain url for others to preview.

## Usage

Add to your .github workflow the action below.

```yml
name: Branch Preview

on: push

jobs:
  deploy:
    name: Deploy
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v2

      - name: Preview Branch
        uses: hyperjumptech/branch-preview@v1
        with:
          dokku_key: ${{ secrets.DOKKU_KEY }}
          host: ${{ secrets.HOST }}
          domain: ${{ secrets.DOMAIN }}
```

## Requirements

You will need a dokku instance and the ssh/private key to push your project to. You will also need a domain already pointing to your dokku.

## Input

You need the following requirements. Please store keys and tokens in secret.

| Requirement  |                 Description                              |
| :----------- | :------------------------------------------------------: |
| HOST         | Dokku Host address (ip) to push your branch to           |
| DOKKU_KEY    | Private/SSH Key to your Dokku instance                   |
| DOMAIN       | Domain to map your deployed branches to                  |

## Output

A dokku app is created from your branch name so that branch should be deployed to `branch_name.yourdomain.com`.  

--  
fork. clone. share.
