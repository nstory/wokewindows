class Pension < ApplicationRecord
  include Attributable

  belongs_to :officer, optional: true
end
