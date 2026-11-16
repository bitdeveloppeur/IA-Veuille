import os
import sys
from scrapy.crawler import CrawlerProcess
from scrapy.utils.project import get_project_settings


sys.path.insert(0, os.path.abspath("."))

# S'assurer que Scrapy charge bien ia_scraper/ia_scraper/settings.py
os.environ.setdefault("SCRAPY_SETTINGS_MODULE", "ia_scraper.ia_scraper.settings")

# Importer le  spider
from ia_scraper.ia_scraper.spiders.articles import SmartAISpider


def run():
    process = CrawlerProcess(get_project_settings())
    process.crawl(SmartAISpider)
    process.start()
    print(" end scrapy.")


if __name__ == "__main__":
    run()
