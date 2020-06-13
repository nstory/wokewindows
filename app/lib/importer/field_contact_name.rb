# imports data from spreadsheets available at:
# https://data.boston.gov/dataset/boston-police-department-fio
# into the field_contact_names table. supports both Mark43 and RMS
# formats. table is truncated before import to prevent duplicates.
# this must be run after Importer::FieldContact

class Importer::FieldContactName
  extend Importer::FieldContactHelpers

  FILES = [
    "data/mark43_fieldcontacts_name_for_public_2019.csv",
    "data/rms_fieldcontacts_name_for_public_2019.csv"
  ]

  def self.import_all
    FieldContactName.destroy_all
    enums = FILES.map { |f| Parser::FieldContactName.new(f).records }
    enum = enums.lazy.flat_map(&:lazy)
    import(enum)
  end

  def self.import(records)
    records.each_slice(500) do |slice|
      FieldContactName.transaction do
        import_slice(slice)
      end
    end
  end

  def self.import_slice(slice)
    # get the FieldContact objects for the fc_nums in this slice so
    # we can set the association
    contacts = FieldContact.where(fc_num: slice.pluck(:fc_num).uniq).to_a
    contacts_by_fc_num = contacts.group_by(&:fc_num).map { |k,v| [k,v.first] }.to_h
    slice.each do |record|
      fcn = new_field_contact_name(record)
      fcn.field_contact = contacts_by_fc_num[fcn.fc_num]
      fcn.save if fcn.field_contact
    end
  end

  def self.new_field_contact_name(record)
    FieldContactName.new({
      fc_num: record[:fc_num],
      contact_date: record[:contact_date],
      sex: parse_string(record[:sex]),
      race: parse_string(record[:race]),
      age: parse_int(record[:age]),
      build: parse_string(record[:build]),
      hair_style: parse_string(record[:hair_style]),
      skin_tone: parse_string(record[:skin_tone]),
      ethnicity: parse_string(record[:ethnicity]),
      other_clothing: parse_string(record[:otherclothing]),
      deceased: parse_boolean(record[:deceased]),
      license_state: parse_string(record[:license_state]),
      license_type: parse_string(record[:license_type]),
      frisked_searched: parse_boolean(record[:frisk_search])
    })
  end
end
