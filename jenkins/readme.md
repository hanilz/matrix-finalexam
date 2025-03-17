# Hanil Zarbailov Final Exam Repo - Jenkins
This folder includes the fixed `app.py` file which runs a Flask app, a corresponding `requirements.txt` file, a multi-stage (builder-runner) `Dockerfile` for building the application image and a `Jenkinsfile` for configuring a pipeline which checks the application (linting and security checks), builds the docker image and pushes it to a Dockerhub repo that exists here:

https://hub.docker.com/repository/docker/hanilz/final-exam/general

## Jenkinsfile Explanation
*NOTE:* Make sure you configured your Dockerhub credentials in your Jenkins admin panel first!

1. We clone this repository in the `jekins` (I had a typo, I know) branch.
2. We run parallely and execute linting and security checks (we continue anyway if any of them fail).
3. We build the Docker image
4. We push it to Dockerhub using our stored credentials securely.
