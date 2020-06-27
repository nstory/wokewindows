class Importer::EmployeeEarnings < Importer::Importer
  SLICE = 1000
  FILE_BY_YEAR = {
    2019 => "data/allemployeescy2019_feb19_20final-all.csv.gz",
    2011 => "data/employee-earnings-report-2011.csv.gz",
    2012 => "data/employee-earnings-report-2012.csv.gz",
    2013 => "data/employee-earnings-report-2013.csv.gz",
    2014 => "data/employee-earnings-report-2014.csv.gz",
    2015 => "data/employee-earnings-report-2015.csv.gz",
    2016 => "data/employee-earnings-report-2016.csv.gz",
    2017 => "data/employee-earnings-report-2017.csv.gz",
    2018 => "data/employeeearningscy18full.csv.gz"
  }

  def self.import_all
    Compensation.delete_all
    FILE_BY_YEAR.each do |year, filename|
      parser = Parser::EmployeeEarnings.new(filename)
      new(parser).import(year)
    end
  end

  def import(year)
    records.select { |r| r[:department] =~ /^Boston Police/i }
      .each_slice(SLICE) do |slice|
      Compensation.transaction do
        import_slice(year, slice)
      end
    end
  end

  def import_slice(year, slice)
    slice.each do |record|
      import_record(year, record)
    end
  end

  def import_record(year, record)
    Compensation.create({
      name: record[:name],
      department_name: record[:department],
      title: record[:title],
      regular: parse_money(record[:regular]),
      retro: parse_money(record[:retro]),
      other: parse_money(record[:other]),
      overtime: parse_money(record[:overtime]),
      injured: parse_money(record[:injured]),
      detail: parse_money(record[:detail]),
      quinn: parse_money(record[:quinn]),
      total: parse_money(record[:total]),
      postal: record[:postal].to_i,
      year: year,
      attributions: [attribution]
    })
  end

  def parse_money(money)
    money = money.gsub(/[^\d.]/, "")
    if /^\d+\.\d\d$/ =~ money
      money.to_f
    else
      0
    end
  end
end
