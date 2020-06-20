# for parsing: data/2014_Officer__IA_Log_redacted.csv
class Parser::OfficerIaLog < Parser::Csv
  MAPPING = {
    involved_officer_s_: :involved_officers,
    allegation_s_force_type_s_: :allegations
  }

  def category
    "2014_officer_ia_log"
  end

  def map_key(key)
    MAPPING.fetch(key, key)
  end
end
