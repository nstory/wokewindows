class Overtime < ApplicationRecord
  include Attributable
  belongs_to :officer, optional: true
end
