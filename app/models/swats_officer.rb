class SwatsOfficer < ApplicationRecord
  belongs_to :swat
  belongs_to :officer, optional: true
  counter_culture :officer, column_name: "swats_count"
end
