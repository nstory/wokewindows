class Importer::FieldContact
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
    "data/rms_fieldcontacts_for_public_2019.csv"
  ]

  def self.import_all
    enums = FILES.map { |f| Parser::FieldContact.new(f).records }
    enum = enums.lazy.flat_map(&:lazy)
    import(enum)
  end

  # records provided by Parser::FieldContact
  def self.import(records)
    records.each_slice(1000) do |slice|
      FieldContact.transaction do
        slice.each do |record|
          import_record(record)
        end
      end
    end
  end

  private
  def self.import_record(record)
    begin
      FieldContact.create({
        fc_num: parse_string(record[:fc_num]),
        contact_date: parse_string(record[:contact_date]),
        contact_officer_employee_id: parse_int(record[:contact_officer]),
        contact_officer_name: parse_string(record[:contact_officer_name]),
        supervisor_employee_id: parse_int(record[:supervisor]),
        supervisor_name: parse_string(record[:supervisor_name]),
        street: parse_string(record[:street]),
        city: parse_string(record[:city]),
        state: parse_string(record[:state]),
        zip: parse_string(record[:zip]),
        frisked_searched: parse_booleans([record[:frisked], record[:searchperson], record[:searchvehicle]]),
        stop_duration: parse_stop_duration(record[:stop_duration]),
        circumstance: parse_string(record[:circumstance]),
        basis: parse_string(record[:basis]),
        vehicle_year: parse_int(record[:vehicle_year]),
        vehicle_state: parse_string(record[:vehicle_state]),
        vehicle_model: parse_string(record[:vehicle_model]),
        vehicle_color: parse_string(record[:vehicle_color]),
        vehicle_style: parse_string(record[:vehicle_style]),
        vehicle_type: parse_string(record[:vehicle_type]),
        key_situations: parse_key_situations(record[:key_situations]),
        narrative: parse_string(record[:contact_reason] || record[:narrative]),
        weather: parse_string(record[:weather])
      })
    rescue ActiveRecord::RecordNotUnique => e
      # there's a small number of dups; ignore them
    end
  end

  def self.parse_key_situations(value)
    return [] if value == "NULL" || value.blank?
    value.split(",").map(&:strip)
  end

  def self.parse_int(value)
    (value == "NULL" || value.blank?) ? nil : value.to_i
  end

  def self.parse_string(value)
    (value == "NULL" || value.blank?) ? nil : value
  end

  def self.parse_booleans(values)
    values.include?("Y")
  end

  def self.parse_stop_duration(value)
    return nil if value == "NULL" || value.blank?
    STOP_DURATION_MAPPING.fetch(value, value.to_i)
  end
end
