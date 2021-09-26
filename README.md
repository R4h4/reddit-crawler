# Simple Reddit Crawler

A simple starting point to crawl new Reddit submissions within a set of Subreddits 
running on AWS ECS.

## Preparation
Multiple steps are needed to make this work.

### 1. Create praw.ini in root
This file contains your Reddit API credentials. ([Documentation](https://praw.readthedocs.io/en/stable/getting_started/configuration/prawini.html))

Example:
```praw.ini
[crawler]
client_id=abcd1234
client_secret=987654321
refresh_token=XYZ
```

### 2. Create crawler_config.yml in root
This is your main configuration file for the crawler. It's primarily used to specify
the Subreddits the bot is supposed to observe.

Example:
```yaml
subreddits:
  - python
  - redditdev
```
