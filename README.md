# pre-commit-mirror-checkstyle

A mirror of the checkstyle linting tool for use in pre-commit hooks

## Usage

Add the following code to your repo's `.pre-commit-config.yaml`

> `- hooks:`  
`- id: checkstyle-java`  
`repo: https://github.com/rgraue/pre-commit-mirror-checkstyle`  
`rev: v0.1.9`  

## Notes

`pre-commit` does not officially support **java** so this hook downloads all necessary files inside the repo under `.checkstyle` folder.
