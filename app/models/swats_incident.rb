class SwatsIncident < ApplicationRecord
  belongs_to :swat
  belongs_to :incident, optional: true
end
