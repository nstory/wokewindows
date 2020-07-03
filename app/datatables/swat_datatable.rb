class SwatDatatable < ApplicationDatatable
  def view_columns
    @view_columns ||= {
      swat_number: {source: "Swat.swat_number"},
      date: {source: "Swat.date", nulls_last: true}
    }
  end

  def data_record(record)
    {
      url: swat_url(record),
      swat_number: record.swat_number,
      date: record.date
    }
  end

  def get_raw_records
    q = Swat.all
    if params[:officer_id]
      q = q.includes(:swats_officers).references(:swats_officers).where("swats_officers.officer_id" => params[:officer_id])
    end
    q
  end
end
