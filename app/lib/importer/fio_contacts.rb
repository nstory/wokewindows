# import fio_contacts.csv file from
# https://github.com/jacoblurye/bpd-fio-data
class Importer::FioContacts < Importer::Importer
  def self.import_all
    parser = Parser::FioContacts.new("data/fio_contacts.csv.gz")
    new(parser).import
  end

  def import
    @by_employee_id = Officer.by_employee_id
    records.each_slice(1000) do |slice|
      FieldContact.transaction do
        import_slice(slice)
      end
    end
  end

  private
  def import_slice(slice)
    fc_nums = slice.pluck(:fc_num)
    fc_num_to_model = field_contacts_by_fc_num(fc_nums)
    slice.each do |record|
      import_record(record, fc_num_to_model[record[:fc_num]])
    end
  end

  def import_record(record, model)
    model.fc_num = record[:fc_num]
    model.supervisor_employee_id = parse_int(record[:supervisor])
    model.supervisor_name = parse_string(record[:supervisor_name])
    model.contact_officer_employee_id = parse_int(record[:contact_officer])
    model.contact_officer_name = parse_string(record[:contact_officer_name])
    model.city = parse_string(record[:city])
    model.stop_duration = parse_enum(record[:stop_duration])
    model.zip = parse_int(record[:zip])
    model.basis = parse_enum(record[:basis])
    model.vehicle_color = parse_string(record[:vehicle_color])
    model.vehicle_make = parse_string(record[:vehicle_make])
    model.state = parse_string(record[:state])
    model.vehicle_state = parse_string(record[:vehicle_state])
    model.vehicle_year = parse_int(record[:vehicle_year])
    model.circumstance = parse_string(record[:circumstance])
    model.vehicle_type = parse_string(record[:vehicle_type])
    model.vehicle_style = parse_string(record[:vehicle_style])
    model.vehicle_model = parse_string(record[:vehicle_model])
    model.contact_date = parse_string(record[:contact_date])
    model.street = parse_string(record[:street])
    model.key_situations = parse_key_situations(record[:key_situations])
    model.weather = parse_string(record[:weather])
    model.narrative = parse_string(record[:narrative])
    model.frisked_searched = parse_boolean(record[:fc_involved_frisk_or_search])
    model.search_vehicle = parse_boolean(record[:searchvehicle])
    model.summons_issued = parse_boolean(record[:summonsissued])
    model.contact_officer = map_officer(model.contact_officer_employee_id)
    model.supervisor = map_officer(model.supervisor_employee_id)
    model.add_attribution attribution
    model.save!
  end

  def parse_enum(str)
    str.blank? ? nil : str.gsub(/ |-/, "_")
  end

  def parse_key_situations(str)
    str.blank? ? [] : str.split(",").map(&:strip)
  end

  def map_officer(employee_id)
    @by_employee_id[employee_id]
  end

  def field_contacts_by_fc_num(fc_nums)
    fc_num_to_model = Hash.new { |h,k| h[k] = FieldContact.new }
    fc_num_to_model.merge!(
      FieldContact.where(fc_num: fc_nums).index_by(&:fc_num)
    )
    fc_num_to_model
  end
end
