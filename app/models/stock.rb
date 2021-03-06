# == Schema Information
#
# Table name: stocks
#
#  id         :integer          not null, primary key
#  symbol     :string
#  company    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  last_price :float
#

class Stock < ActiveRecord::Base
  attr_accessor :positive, :negative
  
  include Findable, SentimentAnalysis
  has_many :user_stocks
  has_many :users, through: :user_stocks

  def followed_by?(user)
    user.stocks.include?(self)
  end

  def dates(days=365)
    MarketData.chart(self.symbol, days)["Dates"]
  end

  def prices(days=365)
    begin 
      MarketData.chart(self.symbol, days)["Elements"][0]["DataSeries"]["close"]["values"]
    rescue
    end
  end

  def quote
    @quote ||=StockQuote::Stock.quote(symbol)
  end

  def prices_with_weekend(days=365)
    new_prices = prices(days).zip(dates(days).map{|d| Date.parse(d)})
    days.times do |i|
      if i < days - 1
        unless new_prices[i][1] + 1 == new_prices[i+1][1]
          new_prices.insert(i+1 ,[new_prices[i][0], new_prices[i][1] + 1])
        end
      end
    end
    new_prices.map(&:first)
  end

  def predictions
  end
end

