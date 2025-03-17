# Hanil Zarbailov Final Exam Repo - Fix app.py
This folder includes the fixed `app.py` file which runs a Flask app, a corresponding `requirements.txt` file and a multi-stage (builder-runner) `Dockerfile` for building the application image.

## What The Bug Was
Originally, no resources were fetched using `boto3` commands. 

**In short - we tried to go over lists that weren't defined!**

I fixed it by using the corresponding `boto3` commands for each resource type:
```python
vpcs = ec2_client.describe_vpcs()
lbs = elb_client.describe_load_balancers()
amis = ec2_client.describe_images(Owners=["self"])
```

## Running Locally
*NOTE:* Make sure you configured the `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` environment variables first!
```bash
python app.py
```

## Docker Build & Run
### build
```bash
docker build -t flask-fix-test .
```
### Run
*NOTE:* Make sure you configured the `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` environment variables first!

```bash
docker run -p 5001:5001 -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY flask-fix-test
```
Or, for detached run:
```bash
docker run -p 5001:5001 -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY -d flask-fix-test
```