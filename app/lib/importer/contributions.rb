class Importer::Contributions < Importer::Importer
  def self.import_all
    import_ocpf
    import_fec
  end

  def self.import_ocpf
    parser = Parser::Ocpf.new(
      "data/ocpf_20200827.csv.gz",
      "data/ocpf_registered_all_20200827.csv.gz"
    )
    new(parser, OcpfContribution).import
  end

  def self.import_fec
    parser = Parser::Fec.new("data/fec_20200827.csv.gz")
    new(parser, FecContribution).import
  end

  def initialize(parser, clazz)
    super(parser)
    @clazz = clazz
  end

  def import
    @officer_matcher = OfficerMatcher.new(:last_first_regexp)
    @clazz.transaction do
      @clazz.delete_all
      records.each do |r|
        if @clazz == OcpfContribution
          OcpfContribution.create!(map_ocpf_record(r))
        elsif @clazz == FecContribution
          FecContribution.create!(map_fec_record(r))
        end
      end
    end
  end

  private
  def map_fec_record(r)
    {
      date: parse_date(r[:contribution_receipt_date]),
      contributor: parse_string(r[:contributor_name]),
      zip: parse_zip(r[:contributor_zip]),
      amount: parse_int(r[:contribution_receipt_amount]),
      occupation: parse_string(r[:contributor_occupation]),
      employer: parse_string(r[:contributor_employer]),
      committee_name: parse_string(r[:committee_name]),
      committee_id: parse_string(r[:committee_id]),
      memo_text: parse_string(r[:memo_text]),
      receipt_type_full: parse_string(r[:receipt_type_full]),
      officer: find_officer(r[:contributor_name]),
      party_affiliation: COMMITTEE_PARTY_MAPPING.fetch(r[:committee_id]) # error if not found
    }
  end

  def map_ocpf_record(r)
    {
      date: parse_date(r[:date]),
      contributor: parse_string(r[:contributor]),
      zip: parse_zip(r[:zip]),
      amount: parse_money(r[:amount]),
      cpf_id: parse_int(r[:cpf_id]),
      candidate_full_name: parse_string(r[:candidate_full_name]),
      office_type: parse_string(r[:office_type]),
      district: parse_string(r[:district]),
      party_affiliation: parse_string(r[:party_affiliation]),
      officer: find_officer(r[:contributor]),
      occupation: parse_string(r[:occupation]),
      employer: parse_string(r[:employer]),
      committee_name: parse_string(r[:comm_name])
    }
  end

  def parse_zip(txt)
    # weird zips like 21322923 should be 02132
    txt = txt[0...4] if txt.length == 8
    parse_int(txt)
  end

  def find_officer(name)
    # sometimes there are years in names e.g. "Kirk 2019, James"; remove that
    name = name.gsub(/\d+/, "")

    # hard-coded mappings
    if NAME_EMPLOYEE_ID_MAPPING[name.downcase]
      return Officer.find_by(employee_id: NAME_EMPLOYEE_ID_MAPPING[name.downcase])
    end

    officers = @officer_matcher.matches(name)
    officers.count == 1 ? officers.first : nil
  end

  COMMITTEE_PARTY_MAPPING = {
    "C00000935" => "Democratic",
    "C00003418" => "Republican",
    "C00010603" => "Democratic",
    "C00027466" => "Republican",
    "C00053553" => "Republican",
    "C00196774" => "Democratic",
    "C00336388" => "Democratic",
    "C00341396" => "Democratic",
    "C00366948" => "Democratic",
    "C00383653" => "Democratic",
    "C00386987" => "Republican",
    "C00401224" => "Democratic",
    "C00409508" => "Democratic",
    "C00430470" => "Republican",
    "C00431171" => "Republican",
    "C00431445" => "Democratic",
    "C00433136" => "Democratic",
    "C00433813" => "Democratic",
    "C00440701" => "Republican",
    "C00446104" => "Republican",
    "C00451393" => "Democratic",
    "C00453738" => "Republican",
    "C00458588" => "Republican",
    "C00466573" => "Democratic",
    "C00467233" => "Republican",
    "C00467621" => "Democratic",
    "C00494120" => "Republican",
    "C00494740" => "Democratic",
    "C00496034" => "Republican",
    "C00498980" => "Democratic",
    "C00500843" => "Democratic",
    "C00512970" => "Democratic",
    "C00515122" => "Democratic",
    "C00518282" => "Republican",
    "C00541185" => "Democratic",
    "C00541540" => "Republican",
    "C00574624" => "Republican",
    "C00575795" => "Democratic",
    "C00577130" => "Democratic",
    "C00580100" => "Republican",
    "C00618371" => "Republican",
    "C00619577" => "Republican",
    "C00631382" => "Republican",
    "C00637611" => "Republican",
    "C00654509" => "Democratic",
    "C00657213" => "Democratic",
    "C00660381" => "Democratic",
    "C00666040" => "Republican",
    "C00667741" => "Democratic",
    "C00688739" => "Democratic",
    "C00694323" => "Republican",
    "C00703975" => "Democratic",
    "C00711549" => "Democratic",
    "C00722132" => "Democratic",
    "C00727156" => "Democratic",
    "C00744201" => "Republican"
  }

  NAME_EMPLOYEE_ID_MAPPING = {
    "broderick, jay" => 10132,
    "gaughan, tim" => 10177,
    "gonsalves, ildo" => 11900,
    "jean-louis, jean" => 102661,
    "brewington, cynthia" => 11952,
    "fabiano, shannon" => 74886,
    "hancock, tim" => 11416,
    "macneil, chris" => 10940,
    "sadatis, paul" => 80395,
    "obrien, jerry" => 12027,
    "beckford brewington, cynthia" => 11952,
    "abdul aziz, ramadani" => 8816,
    "hartgrove, chris" => 8349,
    "cardoso, arisitides" => 99788,
    "terenzi, phil and maureen" => 8368,
    "studley (2019 contribution), john" => 11041,
    "mcgoldrick sr, kevin" => 10566,
    "rogers, jr., john k" => 11357,
    "haseeb, hosein" => 10273,
    "boyle jr., john t." => 10508,
    "joyce, john m." => 8468,
    "mcgrath, doug" => 91907,
    "lauren, woods" => 99755,
    "casinelli jr., michael" => 8830,
    "layden, pat" => 102196,
    "brewster, arthur" => 10269,
    "sanders jr, paul" => 11182
  }
end
