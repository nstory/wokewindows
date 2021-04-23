class Parser::Citations < Parser::Csv
  KEY_MAPPING = {
    :"16pass" => :"16_pass",
    :"citation_" => :ticket_num,
    citation_type: :type,
    viol_type: :violator_type,
    lic_class: :class,
    viol_speed: :violation_speed,
    gender: :sex,
    vhc_color: :vehicle_color,
    make_model: :make,
    vhc_year: :model_yr,
    hazmat: :haz_mat,
    paid_: :paid,
    officerid: :officer_id,
    hearing_requested_: :hearing_requested
  }

  def category
    "2011_2020_citations"
  end

  def map_key(key)
    KEY_MAPPING.fetch(key, key)
  end
end
