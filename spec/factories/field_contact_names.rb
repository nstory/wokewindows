FactoryBot.define do
  factory :field_contact_name do
    field_contact factory: :field_contact
    fc_num { "FC123" }

    factory :field_contact_name_kirk do
      field_contact factory: :field_contact_kirk
      fc_num { "FC234" }
      race { "black" }
      age { 25 }
      build { "heavy" }
      hair_style { "afro" }
      skin_tone { "brown" }
      ethnicity { "not of hispanic origin" }
      other_clothing { "blue hoodie/ jeans" }
      license_state { "ma" }
      license_type { "id only" }
      frisked_searched { true }
      gender { "man" }
    end
  end
end
