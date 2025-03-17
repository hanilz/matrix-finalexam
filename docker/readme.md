# Hanil Zarbailov Final Exam Repo - Terraform
This folder includes the `app.py` file which runs a Flask app, a corresponding `requirements.txt` file and a multi-stage (builder-runner) `Dockerfile` for building the application image.

## Running Locally
*NOTE:* Make sure you configured the `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` environment variables first!
```bash
python app.py
```

## Docker Build & Run
### build
```bash
docker build -t flask-test .
```
### Run
*NOTE:* Make sure you configured the `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` environment variables first!

```bash
docker run -p 5001:5001 -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY flask-test
```
Or, for detached run:
```bash
docker run -p 5001:5001 -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY -d flask-test
```