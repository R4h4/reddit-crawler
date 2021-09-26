import json
import logging

import yaml
import praw


logger = logging.getLogger('MainCrawler')
logger.setLevel(logging.INFO)


reddit = praw.Reddit(
    'crawler',
    user_agent="linux:subreddit_crawler:v0.1 (by u/r4h4_de)",
    redirect_uri="http://localhost:8080/",
)


def main():
    with open('crawler_config.yml', 'r') as config_file:
        configs = yaml.load(config_file, Loader=yaml.FullLoader)
    subreddits = configs['subreddits']

    with open('posts.json', 'a') as file:
        for submission in reddit.subreddit('+'.join(subreddits)).stream.submissions():
            file.write(json.dumps({
                'name': submission.name,
                'created_utc': submission.created_utc,
                'is_self': submission.is_self,
                'score': submission.score,
                'upvote_ratio': submission.upvote_ratio,
                'over_18': submission.over_18,
                'is_original_content': submission.is_original_content,
                'num_comments': submission.num_comments,
                'url': submission.url,
                'author_name': submission.author.name
            }))
            file.write('\n')
            logger.info(f'Added post {submission.name}')


if __name__ == '__main__':
    logger.info('Starting crawler script')
    main()