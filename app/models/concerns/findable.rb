module Findable
  def times_base_uri
    "http://api.nytimes.com/svc/search/v2/articlesearch"
  end

  def find_articles
    uri = URI.parse("#{times_base_uri}.json?q=#{symbol}&sort=newest&fq=news_desk:(business)&fl=web_url,snippet&begin_date=20130601&api-key=#{ENV['TIMES_ARTICLE_KEY']}")
    resp = JSON Net::HTTP.get(uri)
    resp['response']['docs']
  end

  def find_tweets(n = 5)
    $twitter_client.search(symbol, result_type: "recent").take(n).collect do |tweet|
      tweet.text
    end
  end
end