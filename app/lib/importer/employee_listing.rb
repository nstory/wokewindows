# imports into officers a list of BPD employees created by either
# Parser::Cy2015AnnualEarnings or Parser::AlphaListing or
# Parser::AlphaListing2020
class Importer::EmployeeListing < Importer::Importer

  SLICE_SIZE = 500

  PARSERS = {
    "data/CY2015_Annual_Earnings_BPD.csv.gz" => Parser::Cy2015AnnualEarnings,
    "data/ALPHa_LISTING_BPD_with_badges_1.csv.gz" => Parser::AlphaListing,
    "data/alpha_listing_20200715.csv.gz" => Parser::AlphaListing2020
  }

  def self.import_all
    PARSERS.each do |file, klass|
      if File.exist?(file)
        parser = klass.new(file)
        new(parser).import
      end
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

      # the call to compact() ensures we don't overwrite existing values
      # with nil
      officer.attributes = {
        employee_id: employee_id,
        hr_name: parse_string(record[:name]),
        doa: parse_doa(record[:doa]),
        badge: parse_badge(record[:badge]),
        rank: parse_rank(record[:rank_rank]),
        organization: parse_organization(record[:org_description])
      }.compact

      # title is normally populated from the earnings report, the listings
      # also have the title but it's sometimes truncated, so, don't overwrite
      # one from the earnings report
      officer.title = parse_string(record[:title]) if !officer.title

      officer.add_attribution(attribution)
      officer.save
    end
  end

  private
  def parse_badge(txt)
    return nil if txt.blank?
    txt.sub(/^0+/, "")
  end

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

  def parse_organization(txt)
    return nil if txt.blank?
    txt.gsub(/\s+/, " ") # sometimes has double-spaces
  end

  def parse_rank(txt)
    return nil if txt.blank?
    txt.downcase
  end
end
