class Importer::DistrictJournal
  def self.import(records)
    officer_by_employee_id = Hash.new { |h,k| h[k] = Officer.new }
    officer_by_employee_id.merge!(Officer.find_each.index_by(&:employee_id))

    extracted_by_employee_id = extract_officers(records).group_by { |e| e[:employee_id] }
    unique_records = extracted_by_employee_id.map do |employee_id, list|
      most_frequent(list)
    end

    unique_records.each do |record|
      import_record(record, officer_by_employee_id)
    end
  end

  private
  def self.import_record(attrs, officer_by_employee_id)
    officer = officer_by_employee_id[attrs[:employee_id]]
    officer.attributes = attrs
    officer.save
  end

  def self.extract_officers(records)
    records.pluck(:officer).map do |officer|
      if /^(\d{4,})  (.*)$/ =~ officer
        {employee_id: $1.to_i, journal_name: $2}
      else
        nil
      end
    end.compact
  end

  def self.most_frequent(list)
    hash = list.inject(Hash.new 0) { |h,v| h[v] += 1; h }
    hash.max_by { |k,v| v }.first
  end
end
