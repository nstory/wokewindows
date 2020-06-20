require "csv"

class Parser::Csv < Parser::Parser
  def records
    Enumerator.new do |y|
      ::CSV.open(@filename, headers: true, external_encoding: "ISO-8859-1") do |csv|
        csv.each do |row|
          record = row.map { |k,v| [k.downcase.strip.gsub(/[^a-z0-9]+/, "_").to_sym, (v || "").gsub(/[^[[:ascii:]]]/, "").strip] }.to_h
          record = record.map { |k,v| [map_key(k), v] }.to_h
          y << record if filter(record)
        end
      end
    end
  end

  # override to filter out records
  def filter(record)
    true
  end

  # override to change key names, etc.
  def map_key(key)
    key
  end
end
