class IncidentOfficer < ApplicationRecord
  belongs_to :officer, optional: true
  belongs_to :incident

  counter_culture :officer, column_name: :incidents_count

  # parses journal_officer
  def employee_id
    if matches = match_regexp
      matches[1].to_i
    else
      nil
    end
  end

  # parses journal_officer
  def employee_name
    if matches = match_regexp
      matches[2].strip
    else
      nil
    end
  end

  private
  def match_regexp
    /^(\d{4,})  (.+)+$/.match(journal_officer)
  end
end
