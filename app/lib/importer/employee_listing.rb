# imports into officers a list of BPD employees created by either
# Parser::Cy2015AnnualEarnings or Parser::AlphaListing
class Importer::EmployeeListing < Importer::Importer

  SLICE_SIZE = 500

  def self.import_all
    parsers = [
      Parser::Cy2015AnnualEarnings.new("data/CY2015_Annual_Earnings_BPD.csv"),
      Parser::AlphaListing.new("data/ALPHa_LISTING_BPD_with_badges_1.csv")
    ]

    parsers.each do |parser|
      new(parser).import
    end
  end

  def import
    officer_by_employee_id = Officer.find_each.index_by(&:employee_id)
    records.each_slice(SLICE_SIZE) do |slice|
      Officer.transaction do
        import_slice(slice, officer_by_employee_id)
      end
    end
  end

  def import_slice(slice, officer_by_employee_id)
    slice.each do |record|
      employee_id = record[:empl_id].to_i
      officer = officer_by_employee_id.fetch(employee_id) { Officer.new }
      officer.attributes = {
        employee_id: employee_id,
        hr_name: record[:name],
        doa: parse_doa(record[:doa]),
        badge: record[:badge].blank? ? nil : record[:badge]
      }
      officer.add_attribution(attribution)
      officer.save
    end
  end

  private
  # convert 1/2/91 -> 1991-01-02
  def parse_doa(doa)
    if %r{^(\d{1,2})/(\d{1,2})/(\d{1,2})$} =~ doa
      year = $3.to_i
      year += (year < 50 ? 2000 : 1900)
      "#{year}-#{$1.rjust(2, "0")}-#{$2.rjust(2, "0")}"
    else
      nil
    end
  end
end
