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
          port: ${{ secrets.PORT }}
          domain: ${{ secrets.DOMAIN }}
          github_token: ${{ secrets.GITHUB_TOKEN }}
          github_primary_branch: 'main'
```

You can refer to other versions, or even the main branch like so:

```yml
  uses: hyperjumptech/branch-preview@main
```

For convenience, it may be easier to set the input variables as secrets in GitHub. You can then change the value on the fly

## Requirements

You will need a dokku instance and the ssh/private key to push your project to. You will also need a domain already pointing to your dokku. Enable virtualhost in dokku setting, so the apps can be mapped to subdomain.

## Input

You need the following requirements. Please store keys and tokens in secret.

| Requirement  | Description                                                                            |
| :----------- | :------------------------------------------------------------------------------------- |
| host         | Dokku Host address (ip) to push your branch to                                         |
| port         | (optional) If your ssh conenction to dokku is not standard 22, set it here.            |
| domain       | Domain to map your deployed branches to                                                |
| dokku_key    | Private/SSH Key to your Dokku instance                                                 |
| github_token | (automatic) Github access token already provided by github workflow, included for documentation |
| github_primary_branch | (optional) This is your primary git branch, GitHub now defaults to main. set it here |

## Output

A dokku app is created from your branch name so that branch should be deployed to `branch_name.yourdomain.com` when branch_name is not the git primary branch (main/master).

In dokku's view your `branch_name` is just an app. You can check the apps in your dokku by issueing: `dokku apps:list`  

## Troubleshooting

The best way to troubleshoot is to check whether you are able to push from your local to the dokku. All the rights and keys should work from local as from GitHub Actions.

On your local check if this works:

`git push mydokku main:master`

Where `mydokku` is your remote dokku location that you've set using `git remote add mydokku <some address>`.

In the example `main` is just your local git branch as source, it is the default GitHub primary branch. If your local is also `master`, it would look `master:master` in the command above.

If everything works from local, it should transfer seamlessly in GitHub Action. If not, look for the differences.

One note on environment secrets. They do show up as *** in logs, something to note when debugging.

## Contributing

Find any issues? Feedback? Fork, fix and send the PRs this way!

## Docs

1. [changelog](./CHANGELOG.md)
2. [code of conduct](./code_of_conduct.md)
3. [LICENSE](./LICENSE)


--  
fork. clone. share.
