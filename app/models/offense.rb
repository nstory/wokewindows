class Offense
  include ActiveModel::Model

  attr_accessor :code, :code_group, :description
  validates :code, numericality: {only_integer: true, allow_nil: true}

  def ==(o)
    o.class == self.class && o.attributes == self.attributes
  end
  alias_method :eql?, :==

  def hash
    attributes.hash
  end

  def attributes
    {"code" => code, "code_group" => code_group, "description" => description}
  end
end
