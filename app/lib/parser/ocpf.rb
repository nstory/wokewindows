# Parser for contribution reports downloaded from OCPF:
# https://www.ocpf.us/Reports/SearchItems
# joins the data with the "Candidates and Candidate's Committees" file from here:
# https://www.ocpf.us/Data
class Parser::Ocpf < Parser::Csv
  def initialize(filename, committee_file)
    super(filename)
    load_committee_file(committee_file)
  end

  def map_record(record)
    comm = @committees.fetch(record[:cpf_id], Hash.new(""))
    record[:comm_name] = comm["Comm_Name"]
    record[:party_affiliation] = comm["Party_Affiliation"]
    record[:candidate_full_name] = comm["Candidate_Full_Name"]
    record[:office_type] = comm["Office_Type"]
    record[:district] = comm["District"]
    record
  end

  def category
    "ocpf"
  end

  private
  def load_committee_file(committee_file)
    @committees = CSV.new(io_from_file(committee_file), headers: true).map do |row|
      [row["CPF_ID"], row.to_h.slice("Comm_Name", "Party_Affiliation", "Candidate_Full_Name", "Office_Type", "District")]
    end.to_h
  end
end
