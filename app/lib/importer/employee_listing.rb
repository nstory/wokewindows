# imports into officers a list of BPD employees
class Importer::EmployeeListing < Importer::Importer

  SLICE_SIZE = 500

  PARSERS = [
    ["data/CY2015_Annual_Earnings_BPD.csv.gz", Parser::Cy2015AnnualEarnings, false],
    ["data/ALPHa_LISTING_BPD_with_badges_1.csv.gz", Parser::AlphaListing, false],
    ["data/alpha_listing_20200715.csv.gz", Parser::AlphaListing2020, true],
    ["data/roster_20200904.csv.gz", Parser::Roster20200904, false]
  ]

  def self.import_all
    PARSERS.each do |file, klass, set_active|
      if File.exist?(file)
        parser = klass.new(file)
        new(parser, set_active).import
      end
    end
  end

  def initialize(parser, set_active = false)
    super(parser)
    @set_active = set_active
  end

  def import
    officer_by_employee_id = Officer.find_each.index_by(&:employee_id)
    records.each_slice(SLICE_SIZE) do |slice|
      Officer.transaction do
        import_slice(slice, officer_by_employee_id)
      end
    end

    if @set_active
      Officer.transaction do
        Officer.update_all "active = false"
        records.pluck(:empl_id).each do |ei|
          Officer.where(employee_id: ei).update_all("active = true")
        end
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
        organization: parse_organization(record[:org_description]),
        title: parse_string(record[:title]),
        start_date: parse_date(record[:start_date]),
        sex: parse_string(record[:sex]),
        ethnic_group: parse_string(record[:ethnic_grp]),
      }.compact

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
