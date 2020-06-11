require "csv"

class LoadCrimeIncidentReports
  def initialize(filename)
    @filename = filename
  end

  def get_records
    Enumerator.new do |y|
      CSV.open(@filename, headers: true) do |csv|
        csv.each do |row|
          y << row.map { |k,v| [k.downcase.to_sym, v] }.to_h
        end
      end
    end
  end
end
