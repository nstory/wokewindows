class DetailDatatable < ApplicationDatatable
  def view_columns
    @view_columns ||= {
      tracking_no: {source: "Detail.tracking_no", searchable: false},
      employee_name: {source: "Detail.employee_name", searchable: false},
      customer_name: {source: "Detail.customer_name", searchable: false},
      address: {source: "Detail.address", searchable: false},
      start_date_time: {source: "Detail.start_date_time", searchable: false},
      minutes_worked: {source: "Detail.minutes_worked", searchable: false},
      pay_amount: {source: "Detail.pay_amount", searchable: false},
      bag_of_text: {source: "Detail.bag_of_text", searchable: true, orderable: false}
    }
  end

  def data_record(record)
    {
      url: detail_url(record),
      tracking_no: record.tracking_no,
      employee_name: record.employee_name,
      customer_name: record.customer_name,
      address: record.address,
      start_date_time: record.start_date_time,
      minutes_worked: record.minutes_worked,
      pay_amount: record.pay_amount
    }
  end

  def get_raw_records
    q = Detail.all
    if params[:officer_id]
      q = q.where("officer_id" => params[:officer_id])
    end
    q
  end
end
