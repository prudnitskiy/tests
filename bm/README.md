# Test assignement readme

## Goal

This repository contains:
- a simple web server (golang, no external libs)
- infrastructure definition to deploy and run this webserver on AWS EKS
- pipeline definition to deploy updated version of code to EKS cluster using GitHub Actions

## Warning and limitations

This code is not implied to use in production and contains some security and reliability flaws. It was made intentionally to speed up and simply deployment.

Minimal versions of tools required to run this code:
- Terraform >= 0.13
- AWS CLI >= 2.7
- Helm >= 3.8

## Operations

To update the code:
- make changes
- create a tag with: `git tag {tag_version} -a -m "{update_message}`
- push the tag to the repo with: `git push tag origin`

This will start the pipeline (normally takes about a minute) to update the deployment. The resulting URL will be displayed in job output.
