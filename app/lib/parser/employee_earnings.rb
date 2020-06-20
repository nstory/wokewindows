class Parser::EmployeeEarnings < Parser::Csv
  MAPPING = {
    :department => :department,
    :department_name => :department,
    :detail => :detail,
    :details => :detail,
    :injured => :injured,
    :name => :name,
    :other => :other,
    :overtime => :overtime,
    :postal => :postal,
    :quinn => :quinn,
    :quinn_education_incentive => :quinn,
    :regular => :regular,
    :retro => :retro,
    :title => :title,
    :total_earnings => :total,
    :zip_code => :postal,
    :zip => :postal
  }

  def category
    "employee_earnings"
  end

  def map_key(key)
    MAPPING.fetch(key, key)
  end
end
