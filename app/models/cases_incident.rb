class CasesIncident < ApplicationRecord
  belongs_to :case
  belongs_to :incident, optional: true
end
