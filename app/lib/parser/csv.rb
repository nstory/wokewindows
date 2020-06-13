require "csv"

class Parser::Csv
  def initialize(filename)
    @filename = filename
  end

  def records
    Enumerator.new do |y|
      ::CSV.open(@filename, headers: true, external_encoding: "ISO-8859-1") do |csv|
        csv.each do |row|
          record = row.map { |k,v| [k.downcase.strip.gsub(/[^a-z0-9]+/, "_").to_sym, (v || "").gsub(/[^[[:ascii:]]]/, "")] }.to_h
          y << record
        end
      end
    end
  end
end
