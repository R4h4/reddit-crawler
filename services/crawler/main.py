from time import sleep
import logging

import yaml
import praw

from services.kinesis import put_record

logger = logging.getLogger('MainCrawler')
logger.setLevel(logging.INFO)


reddit = praw.Reddit(
    'crawler',
    user_agent="linux:subreddit_crawler:v0.1 (by u/r4h4_de)",
    redirect_uri="http://localhost:8080/",
)


def main():
    logger.info('Starting main function')
    with open('crawler_config.yml', 'r') as config_file:
        configs = yaml.load(config_file, Loader=yaml.FullLoader)
    subreddits = configs['subreddits']

    try:
        for submission in reddit.subreddit('+'.join(subreddits)).stream.submissions():
            res = put_record({
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
            })
            logger.debug(f'Added post {submission.name}')
    except Exception as e:
        logger.error(f'Script stopped due to error: {type(e)} {e}, retrying in 5 seconds')
        sleep(5)
        main()


if __name__ == '__main__':
    print('Start')
    logger.info('Starting crawler script')
    main()
