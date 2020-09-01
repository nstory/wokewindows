class Contribution < ApplicationRecord
  belongs_to :officer, optional: true
end
