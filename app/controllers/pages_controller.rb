class PagesController < ApplicationController
  
  before_action :setup

  def setup
  @web = HTTParty.get('https://secure.runescape.com/m=itemdb_rs/api/catalogue/items.json?category=18&alpha=a&page=1')
  @json = @web.parsed_response
  @json = JSON.parse(@json)
  end

  def index

  end

  def show
  @item_id = params['format']
  @web = HTTParty.get('https://secure.runescape.com/m=itemdb_rs/api/catalogue/detail.json?item=' + @item_id.to_s)
  @json = @web.parsed_response
  @json = JSON.parse(@json)

  
  # repeating this for 30 90 and 180 days to get what the price should have been at that time
  # using the percentage change and the current price
  @price = @json['item']['current']['price']
  puts 'price before is: ' + @price
  if(@price[-1] == 'm')
    @price = @price.to_f * 1000000
  elsif (@price[-1] == 'k')
    @price = @price.to_f * 1000
  end

  puts 'price is ' + @price.to_s

  @day180P = @json['item']['day180']['change']
  @day180P.slice!('%')
  @day180P.slice!('+')
  @day180P = 100 * (@price / (100 - -@day180P.to_f))
  puts @day180P

  @day90P = @json['item']['day90']['change']
  @day90P.slice!('%')
  @day90P.slice!('+')
  @day90P = 100 * (@price / (100 - -@day90P.to_f))
  puts @day90P

  
  @day30P = @json['item']['day30']['change']
  @day30P.slice!('%')
  @day30P.slice!('+')
  @day30P = 100 * (@price / (100 - -@day30P.to_f))
  puts @day30P

  @data = {
    'day180': @day180P, 
    'day90': @day90P, 
    'day30': @day30P, 
    'today': @price + @json['item']['today']['price'].to_f, 
    'current': @price
  }
  end
  
  def about
  end
  
end
