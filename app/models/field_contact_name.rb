class FieldContactName < ApplicationRecord
  include Attributable

  belongs_to :field_contact
  counter_culture :field_contact

  enum race: {
    black: "black",
    native_american: "native american / alaskan native",
    asian: "asian",
    native_hawaiian: "native hawaiian / other pacific islander",
    unknown: "unknown",
    white: "white",
    other: "other"
  }
end
