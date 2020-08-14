class NibrsOffense
  include ActiveModel::Model

  attr_accessor(
    :ucr_code,
    :description,
    :attempted_or_completed,
    :number_of_crimes,
    :number_of_victims,
    :number_of_stolen_vehicles,
    :number_of_recovered_vehicles,
    :method_of_entry,
    :number_of_premises_entered
  )

  def ==(o)
    o.class == self.class && o.attributes == self.attributes
  end
  alias_method :eql?, :==

  def hash
    attributes.hash
  end

  def attributes
    {
      "ucr_code" => ucr_code,
      "description" => description,
      "attempted_or_completed" => attempted_or_completed,
      "number_of_crimes" => number_of_crimes,
      "number_of_victims" => number_of_victims,
      "number_of_stolen_vehicles" => number_of_stolen_vehicles,
      "number_of_recovered_vehicles" => number_of_recovered_vehicles,
      "method_of_entry" => method_of_entry,
      "number_of_premises_entered" => number_of_premises_entered
    }
  end
end
