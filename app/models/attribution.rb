# an Attribution object links a record to a source document from which it
# was imported. a given record may have multiple Attributions
class Attribution
  include ActiveModel::Model
  attr_accessor :filename, :category, :url
  validates :filename, :category, presence: true, strict: true

  def ==(o)
    o.class == self.class && o.attributes == self.attributes
  end
  alias_method :eql?, :==

  def attributes
    {"filename" => filename, "category" => category, "url" => url}
  end
end
