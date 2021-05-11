class PagesController < ApplicationController
  before_action :setup, only: :index

  def index

  end

  def show
  @item_id = params['format']
  @web = HTTParty.get('https://secure.runescape.com/m=itemdb_rs/api/catalogue/detail.json?item=' + @item_id.to_s)
  @json = @web.parsed_response
  @json = JSON.parse(@json)

  
  @day180P = @json['item']['day180']['change']
  @day180P.slice!('%')
  @day180P.slice!('+')
  @day180P = 100 * (@json['item']['current']['price'].to_f / (100 - @day180P.to_f))
  puts @day180P

  @day90P = @json['item']['day90']['change']
  @day90P.slice!('%')
  @day90P.slice!('+')
  @day90P = 100 * (@json['item']['current']['price'].to_f / (100 - @day90P.to_f))
  puts @day90P

  @day30P = @json['item']['day30']['change']
  @day30P.slice!('%')
  @day30P.slice!('+')
  @day30P = 100 * (@json['item']['current']['price'].to_f / (100 - @day30P.to_f))
  puts @day30P

  @data = {
    'day180': @day180P, 
    'day90': @day90P, 
    'day30': @day30P, 
    'today': @json['item']['current']['price'].to_f + @json['item']['today']['price'].to_f, 
    'current': @json['item']['current']['price'], 
  }
  end

  def about
  end

  private

  def setup
  #   @web = [] 
  #   # GE_CATEGORIES.times.with_index do |index|
  #   1.times.with_index do |index|
  #     @web[index] = HTTParty.get("https://secure.runescape.com/m=itemdb_rs/api/catalogue/items.json?category=18&alpha=a&page=1")
  #   end

  #   p @web[0].parsed_response

  #   @json = @web[0].parsed_response
  #   @json = JSON.parse(@json)
  end

end
