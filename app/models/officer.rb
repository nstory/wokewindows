class Officer < ApplicationRecord
  # imports officer information produced by LoadDistrictJournal
  def self.import_from_journal_records(records)
    records.each do |record|
      if /^(\d+) +(.+)$/ =~ record[:officer]
        employee_id = $1.to_i
        journal_name = $2
        officer = Officer.find_or_create_by(employee_id: employee_id)
        if !officer.journal_name
          officer.journal_name = journal_name
          officer.save
        end
      end
    end
  end

  # imports officer information from LoadCsv parsing CY2015_Annual_Earnings_BPD.csv
  def self.import_from_bpd_annual_earnings(records)
    records.each do |record|
      officer = Officer.find_or_create_by(employee_id: record[:empl_id])
      if !officer.hr_name
        officer.hr_name = record[:name]
        officer.save
      end
    end
  end

  # imports officer information from LoadCsv parsing ALPHa_LISTING_BPD_with_badges_1.csv
  def self.import_from_alpha_listing(records)
    records.each do |record|
      officer = Officer.find_or_create_by(employee_id: record[:idno6])
      if !officer.hr_name
        officer.hr_name = record[:name]
        officer.save
      end

      if !officer.doa
        officer.doa = convert_date(record[:doa])
        officer.save
      end
    end
  end

  # imports hr_name from earnings report by fuzzy-matching with journal_name
  def self.import_from_employee_earnings_report(records)
  end

  private
  def self.convert_date(date)
    if %r{^(\d{1,2})/(\d{1,2})/(\d{1,2})$} =~ date
      year = $3.to_i
      year += (year < 50 ? 2000 : 1900)
      "#{year}-#{$1.rjust(2, "0")}-#{$2.rjust(2, "0")}"
    else
      nil
    end
  end
end
