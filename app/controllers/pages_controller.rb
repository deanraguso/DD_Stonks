class PagesController < ApplicationController
  before_action :setup, only: :index

  def index
    response = params.has_key?(:item) ? search_results : nil
    @results = response ? JSON.parse(response.parsed_response)["items"] : nil
    if @results && params[:item]
      @results.select! {|item| 
        item["name"].downcase.include?(params[:item].downcase) 
      } 
    end
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

  def search_results
    # Is a search needed?
    if params[:item].length > 0
      first_letter = params[:item].length == 1 ? params[:item] : params[:item][0]
      category = Constants::CATEGORIES.find_index(params[:category])
        return HTTParty.get("https://secure.runescape.com/m=itemdb_rs/api/catalogue/items.json?category=#{category}&alpha=#{first_letter}&page=1")
    end
    return nil
  end

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
