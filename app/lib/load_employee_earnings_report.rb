require "csv"

# for parsing the reports available at:
# https://data.boston.gov/dataset/employee-earnings-report
class LoadEmployeeEarningsReport
  FILE_BY_YEAR = {
    2019 => "data/allemployeescy2019_feb19_20final-all.csv",
    2011 => "data/employee-earnings-report-2011.csv",
    2012 => "data/employee-earnings-report-2012.csv",
    2013 => "data/employee-earnings-report-2013.csv",
    2014 => "data/employee-earnings-report-2014.csv",
    2015 => "data/employee-earnings-report-2015.csv",
    2016 => "data/employee-earnings-report-2016.csv",
    2017 => "data/employee-earnings-report-2017.csv",
    2018 => "data/employeeearningscy18full.csv"
  }

  def initialize(filename)
    @filename = filename
  end

  def records
    Enumerator.new do |y|
      CSV.open(@filename, headers: true, external_encoding: "ISO-8859-1") do |csv|
        csv.each do |row|
          y << row.map { |k,v| [map_key(k), (v || "").gsub(/[^[[:ascii:]]]/, "")] }.to_h
        end
      end
    end
  end

  def self.all_with_year
    FILE_BY_YEAR.flat_map do |year,file|
      records = LoadEmployeeEarningsReport.new(file).records.to_a
      records.each { |r| r[:year] = year }
      records
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
