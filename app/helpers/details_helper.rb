module DetailsHelper
  def format_detail_employee_name(detail)
    return format_unknown if !detail.employee_name
    return link_to detail.employee_name, officer_path(detail.officer) if detail.officer
    return detail.employee_name
  end

  def format_detail_employee_number(detail)
    return format_unknown if !detail.employee_number
    return link_to detail.employee_number, officer_path(detail.officer) if detail.officer
    return detail.employee_number
  end
end
