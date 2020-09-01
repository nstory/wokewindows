FactoryBot.define do
  factory :contribution do
    factory :contribution_kirk, class: OcpfContribution do
      officer factory: :officer_kirk
      type { "OcpfContribution" }
      date { "2004-04-20" }
      contributor { "James" }
      zip { 2152 }
      employer { "City of Boston" }
      occupation { "Law Enforcement" }
      amount { 0.25e2 }
      committee_name { "Travaglini Committee" }
      cpf_id { 11470 }
      candidate_full_name { "Robert E. Travaglini" }
      office_type { "Senate" }
      district { "1st Suffolk & Middlesex" }
      party_affiliation { "Democratic" }
      committee_id { "C42" }
      memo_text { "da memo" }
      receipt_type_full { "da receipt" }
    end
  end
end
