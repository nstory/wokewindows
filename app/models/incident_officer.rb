class IncidentOfficer < ApplicationRecord
  belongs_to :officer, optional: true
  belongs_to :incident
end
