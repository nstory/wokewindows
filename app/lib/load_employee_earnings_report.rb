# for parsing the reports available at:
# https://data.boston.gov/dataset/employee-earnings-report
class LoadEmployeeEarningsReport
  def initialize(filename)
    @filename = filename
  end

  def records
    Enumerator.new do |y|
      CSV.open(@filename, headers: true) do |csv|
        csv.each do |row|
          y << row.map { |k,v| [map_key(k), v] }.to_h
        end
      end
    end
  end

  private
  def map_key(key)
    mapping = {
      "department name" => :department,
      "department" => :department,
      "department_name" => :department,
      "detail" => :detail,
      "details" => :detail,
      "injured" => :injured,
      "name" => :name,
      "other" => :other,
      "overtime" => :overtime,
      "postal" => :postal,
      "quinn" => :quinn,
      "quinn/education incentive" => :quinn,
      "regular" => :regular,
      "retro" => :retro,
      "title" => :title,
      "total earnings" => :total,
      "zip code" => :postal,
      "zip" => :postal
    }
    mapping.fetch(key.strip.downcase)
  end
end
