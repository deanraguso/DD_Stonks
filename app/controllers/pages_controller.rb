class PagesController < ApplicationController

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
    response = HTTParty.get('https://secure.runescape.com/m=itemdb_rs/api/catalogue/detail.json?item=' + @item_id.to_s)
    @json = JSON.parse(response.parsed_response)

    
    # repeating this for 30 90 and 180 days to get what the price should have been at that time
    # using the percentage change and the current price
    @price = @json['item']['current']['price']
    # puts 'price before is: ' + @price
    if(@price[-1] == 'm')
      @price = @price.to_f * 1_000_000
    elsif (@price[-1] == 'k')
      @price = @price.to_f * 1_000
    end


    @day180P = percent_string_to_change(@json['item']['day180']['change'],
      @price)
    @day90P = percent_string_to_change(@json['item']['day90']['change'], 
      @price)              
    @day30P = percent_string_to_change(@json['item']['day30']['change'], 
      @price)                                   

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


  private
  def percent_string_to_change(ps, price)
    ps.slice!('%')
    ps.slice!('+')
    fraction_change = ps.to_f/100;

    return (1 - fraction_change)*price
  end

  def search_results
    # Is a search needed?
    if params[:item].length > 0
      first_letter = params[:item].length == 1 ? params[:item] : params[:item][0]
      category = Constants::CATEGORIES.find_index(params[:category])
        return HTTParty.get("https://secure.runescape.com/m=itemdb_rs/api/catalogue/items.json?category=#{category}&alpha=#{first_letter}&page=1")
    end
    return nil
  end
end
