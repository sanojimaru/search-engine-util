# -*- coding: utf-8 -*-
require 'rubygems'
require 'mechanize'
require 'uri'

class SearchRankChecker

  GOOGLE = {
    url: 'http://www.google.co.jp/search?ie=UTF-8&hl=en&q=%s&num=%d',
    selector: 'body #res h3.r a',
  }

  YAHOO = {
    url: 'http://search.yahoo.co.jp/search?ei=UTF-8&p=%s&n=%d',
    selector: '#WS2m ul li h3 a',
  }

  USER_AGENT = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_2) AppleWebKit/535.7 (KHTML, like Gecko) Chrome/16.0.912.63 Safari/535.7'

  def initialize(search_engine, user_agent=nil)
    @mechanize = Mechanize.new do |agent|
      agent.user_agent = user_agent || SearchRankChecker::USER_AGENT
    end
    @results = []
    @search_engine = search_engine
  end

  def load_results(search_query, num=100)
    url = URI::parse sprintf(@search_engine[:url], URI.encode(search_query), num)
    @mechanize.get url do |page|
      @results << page
    end
  end

  def check_rank(search_query, target_url)
    url = URI::parse target_url
    rank = -1
    self.load_results search_query

    @results.each_with_index do |res, page_num|
      res.parser().css(@search_engine[:selector]).each_with_index do |link, num|
        href = URI.parse link.attribute('href').to_s
        break rank = (num + 1) * (page_num + 1) if url == href
      end
    end
    rank
  end

end

crawler = SearchRankChecker.new SearchRankChecker::GOOGLE
puts crawler.check_rank '検索エンジン', 'http://ja.wikipedia.org/wiki/%E6%A4%9C%E7%B4%A2%E3%82%A8%E3%83%B3%E3%82%B8%E3%83%B3'

crawler = SearchRankChecker.new SearchRankChecker::YAHOO
puts crawler.check_rank '検索エンジン', 'http://ja.wikipedia.org/wiki/%E6%A4%9C%E7%B4%A2%E3%82%A8%E3%83%B3%E3%82%B8%E3%83%B3'

