class ComplaintOfficer < ApplicationRecord
  belongs_to :complaint
  belongs_to :officer, optional: true
end
