class ForfeituresIncident < ApplicationRecord
  belongs_to :forfeiture
  belongs_to :incident, optional: true
end
