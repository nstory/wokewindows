# import fio_people.csv file from
# https://github.com/jacoblurye/bpd-fio-data
class Importer::FioPeople < Importer::Importer
  def self.import_all
    parser = Parser::FioPeople.new("data/fio_people.csv.gz")
    new(parser).import
  end

  def import
    # for most record types, we try to update any existing record based on the
    # record's unique key. fio_people records do not have a unique key, so, the
    # only way to not insert duplicates is to blow them all away first.
    FieldContactName.delete_all

    records.each_slice(1000) do |slice|
      FieldContactName.transaction do
        import_slice(slice)
      end
    end
  end

  def import_slice(slice)
    fc_nums = slice.pluck(:fc_num)
    fc_by_fc_num = FieldContact.where(fc_num: fc_nums).index_by(&:fc_num)
    slice.each do |record|
      fc = fc_by_fc_num[record[:fc_num]]
      if !fc
        Rails.logger.warn(
          "fio_people record has unknown fc_num #{record[:fc_num]}. skipping."
        )
        next
      end
      FieldContactName.create!({
        fc_num: record[:fc_num],
        field_contact: fc,
        race: parse_string(record[:race]),
        build: parse_string(record[:build]),
        hair_style: parse_string(record[:hair_style]),
        other_clothing: parse_string(record[:otherclothing]),
        age: parse_int(record[:age]),
        ethnicity: parse_string(record[:ethnicity]),
        skin_tone: parse_string(record[:skin_tone]),
        license_state: parse_string(record[:license_state]),
        license_type: parse_string(record[:license_type]),
        frisked_searched: parse_boolean(record[:person_frisked_or_searched]),
        gender: parse_string(record[:gender]),
        attributions: [attribution]
      })
    end
  end
end
