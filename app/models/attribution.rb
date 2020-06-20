# an Attribution object links a record to a source document from which it
# was imported. a given record may have multiple Attributions
class Attribution
  include ActiveModel::Model
  attr_accessor :filename, :category, :url
  validates :filename, :category, presence: true, strict: true
end
