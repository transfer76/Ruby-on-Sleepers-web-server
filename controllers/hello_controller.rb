require_relative '../models/qoute'

class HelloController < BasicController
  def index
    @welcome_title = "Привет, дорогой, сейчас #{Time.now}"
    last_quote = Quote.all.last

    if last_quote.nil?
      @last_quote = 'Ваша цитата будет первой!'
    else
      @last_quote = last_quote.text
    end

    @total_quotes = Quote.all.size
  end

  def save
    quote = Quote.create(params['message'])
    @quote = quote.text
    @time = quote.created_at
  end
end
