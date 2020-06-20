# imports data from spreadsheets available at:
# https://data.boston.gov/dataset/boston-police-department-fio
# into the field_contacts table. supports both Mark43 and RMS
# formats. this is idempotent; duplicates are dropped

class Importer::FieldContact < Importer::Importer

  STOP_DURATION_MAPPING = {
    "Longer Than Two Hours" => 120,
    "Forty-Five to Sixty Minutes" => 45,
    "One to Two Hours" => 60,
    "Thirty to Forty-Five Minutes" => 30,
    "Twenty to Twenty-Five Minutes" => 20,
    "Twenty-Five to Thirty Minutes" => 25,
    "Fifteen to Twenty Minutes" => 15,
    "Less Than Five Minutes" => 1,
    "Ten to Fifteen Minutes" => 10,
    "Five to Ten Minutes" => 5
  }

  FILES = [
    "data/mark43_fieldcontacts_for_public_20192.csv",
    "data/rms_fieldcontacts_for_public_2019.csv",
    "data/rms_fieldcontacts_for_public_2018_202003111433.csv",
    "data/rms_fieldcontacts_for_public_2017_202003111424.csv",
    "data/fieldcontactforpublic2016.csv",
    "data/fieldcontactforpublic2015.csv"
  ]

  def self.import_all
    FILES.each do |file|
      parser = Parser::FieldContact.new(file)
      new(parser).import
    end
  end

  # records provided by Parser::FieldContact
  def import
    records.each_slice(1000) do |slice|
      FieldContact.transaction do
        import_slice(slice)
      end
    end
  end

  private
  def import_slice(slice)
    contacts = slice.map do |record|
      new_field_contact(record)
    end.compact

    # associate the newly created field contacts with officers
    officers = Officer.where(
      employee_id: (contacts.map(&:contact_officer_employee_id) + contacts.map(&:supervisor_employee_id)).uniq
    ).to_a
    emp_id_to_officer = officers.group_by(&:employee_id).map {|k,v| [k,v.first]}.to_h
    contacts.each do |fc|
      fc.contact_officer = emp_id_to_officer[fc.contact_officer_employee_id]
      fc.supervisor = emp_id_to_officer[fc.supervisor_employee_id]
      fc.add_attribution(attribution)
      begin
        fc.save
      rescue ActiveRecord::RecordNotUnique => e
        # there's a small number of dups; ignore them
      end
    end
  end

  def new_field_contact(record)
    FieldContact.new({
      fc_num: parse_nullable_string(record[:fc_num]),
      contact_date: parse_date_time(record[:contact_date]),
      contact_officer_employee_id: parse_nullable_int(record[:contact_officer]),
      contact_officer_name: parse_nullable_string(record[:contact_officer_name]),
      supervisor_employee_id: parse_nullable_int(record[:supervisor]),
      supervisor_name: parse_nullable_string(record[:supervisor_name]),
      street: parse_nullable_string(record[:street]),
      city: parse_nullable_string(record[:city]),
      state: parse_nullable_string(record[:state]),
      zip: parse_nullable_string(record[:zip]),
      frisked_searched: parse_booleans([record[:frisked], record[:searchperson], record[:searchvehicle]]),
      stop_duration: parse_stop_duration(record[:stop_duration]),
      circumstance: parse_nullable_string(record[:circumstance]),
      basis: parse_nullable_string(record[:basis]),
      vehicle_year: parse_nullable_int(record[:vehicle_year]),
      vehicle_state: parse_nullable_string(record[:vehicle_state]),
      vehicle_make: parse_nullable_string(record[:vehicle_make]),
      vehicle_model: parse_nullable_string(record[:vehicle_model]),
      vehicle_color: parse_nullable_string(record[:vehicle_color]),
      vehicle_style: parse_nullable_string(record[:vehicle_style]),
      vehicle_type: parse_nullable_string(record[:vehicle_type]),
      key_situations: parse_key_situations(record[:key_situations]),
      narrative: parse_nullable_string(record[:contact_reason] || record[:narrative]),
      weather: parse_nullable_string(record[:weather])
    })
  end

  def parse_key_situations(value)
    return [] if value == "NULL" || value.blank?
    value.split(",").map(&:strip)
  end

  def parse_booleans(values)
    values.include?("Y")
  end

  def parse_stop_duration(value)
    return nil if value == "NULL" || value.blank?
    STOP_DURATION_MAPPING.fetch(value, value.to_i)
  end

  def parse_date_time(date)
    time = Chronic.parse(date)
    time ? time.strftime("%F %T") : nil
  end
end
