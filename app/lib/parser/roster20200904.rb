class Parser::Roster20200904 < Parser::Csv
  KEY_MAPPING = {
    id: :empl_id,
    ln_fn: :name,
    task_profile_descr: :org_description,
    job_title: :title
  }

  def category
    "roster_20200904"
  end

  def map_key(key)
    KEY_MAPPING.fetch(key, key)
  end
end
