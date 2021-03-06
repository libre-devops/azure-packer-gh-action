# Libre DevOps - Azure Terraform GitHub Action

Hello :wave:

This is an action for running Packer on Azure

# Example Usage
```yaml
name: 'Packer Build'

# Allow run manually
on:
  workflow_dispatch:

jobs:
  azure-terraform-job:
    name: 'Terraform Build'
    runs-on: ubuntu-latest
    environment: tst

    # Use the Bash shell regardless whether the GitHub Actions runner is ubuntu-latest, macos-latest, or windows-latest
    defaults:
      run:
        shell: bash

    steps:
      - uses: actions/checkout@v3

      - name: Libre DevOps - Run Packer for Azure - GitHub Action
        env:
          PKR_VAR_dockerhub_login: ${{ secrets.DockerHubUsername }}
          PKR_VAR_dockerhub_password: ${{ secrets.DockerHubPassword }}
        id: packer-build
        uses: libre-devops/azure-packer-gh-action@v1
        with:
          packer-template-path: "packer/linux/ubuntu/2204/ubuntu2204.pkr.hcl"
          packer-client-id: ${{ secrets.SpokeSvpClientId }}
          packer-client-secret: ${{ secrets.SpokeSvpClientSecret }}
          packer-subscription-id: ${{ secrets.SpokeSubId }}
          packer-tenant-id: ${{ secrets.SpokeTenantId }}


```