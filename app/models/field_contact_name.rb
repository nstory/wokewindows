class FieldContactName < ApplicationRecord
  include Attributable

  belongs_to :field_contact
  counter_culture :field_contact
end
