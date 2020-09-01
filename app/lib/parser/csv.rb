require "csv"

class Parser::Csv < Parser::Parser
  def records
    Enumerator.new do |y|
      csv = CSV.new(io_from_file(@filename), headers: headers)
      csv.each do |row|
        record = row.map { |k,v| [k.downcase.strip.gsub(/[^a-z0-9]+/, "_").to_sym, (v || "").gsub(/[^[[:ascii:]]]/, "").strip] }.to_h
        record = record.map { |k,v| [map_key(k), v] }.to_h
        record = map_record(record)
        y << record if filter(record)
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

  def map_record(record)
    record
  end

  def headers
    true
  end

  private
  def io_from_file(file)
    if /\.gz$/ =~ file.to_s
      Zlib::GzipReader.new(File.open(file, "rb"), external_encoding: "ISO-8859-1")
    else
      File.open(file, external_encoding: "ISO-8859-1")
    end
  end
end
