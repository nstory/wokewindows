class Compensation < ApplicationRecord
  belongs_to :officer, optional: true
end
