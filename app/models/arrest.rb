class Arrest
  include ActiveModel::Serializers::JSON

  attr_accessor :name, :charge

  def initialize(options = {})
    @name = options[:name]
    @charge = options[:charge]
  end

  def attributes=(hash)
    hash.each do |key, value|
      send("#{key}=", value)
    end
  end

  def attributes
    {"name" => nil, "charge" => nil}
  end

  def redact!
    self.name = name.gsub(/(?<!\b)[a-z]/i, "X") if name
  end
end
