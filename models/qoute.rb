class Quote
  attr_accessor :id
  attr_accessor :text
  attr_accessor :created_at

  @@all_models = {}

  def self.create(text)
    model = Quote.new
    model.text = text
    model.created_at = Time.now
    model.save
  end

  def save
    self.id = @@all_models.keys.last.to_i + 1
    @@all_models[self.id] = self

    return self
  end

  def self.all
    @@all_models.values
  end
end  
