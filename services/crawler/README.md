# Crawler image
To update, run the following commands:
```commandline
docker build -t reddit_crawler .
docker tag reddit_crawler:latest 348342725339.dkr.ecr.eu-west-1.amazonaws.com/reddit-crawler-prod-ecr:latest  
docker push 348342725339.dkr.ecr.eu-west-1.amazonaws.com/reddit-crawler-prod-ecr:latest
aws ecs update-service --cluster reddit-crawler-prod-cluster --service reddit-crawler-prod-ecs-service --force-new-deployment
```