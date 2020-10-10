class OrganizationDatatable < ApplicationDatatable
  def view_columns
    @view_columns ||= {
      organization: {source: "Officer.organization", },
      num_employees: {orderable: false, searchable: false}
    }
  end

  def data_record(record)
    {
      url: organization_url(record.organization.parameterize),
      organization: record.organization,
      num_employees: record.num_employees
    }
  end

  def get_raw_records
    Officer.distinct.select("organization, count(employee_id) as num_employees").
      group(:organization).where.not(organization: nil).order("count(employee_id) desc")
  end

  def records_total_count
    fetch_records.size.size
  end

  def records_filtered_count
    filter_records(fetch_records).size.size
  end
end
