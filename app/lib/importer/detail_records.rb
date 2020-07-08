class Importer::DetailRecords < Importer::Importer
  SLICE_SIZE = 1000

  def self.import_all
    parser = Parser::DetailRecords.new(
      "data/Detail_Records_January_to_December_2019.csv.gz"
    )
    new(parser).import
  end

  def import
    @by_employee_id = Officer.by_employee_id
    records.each_slice(SLICE_SIZE) do |slice|
      Detail.transaction do
        import_slice(slice)
      end
    end
  end

  private
  def import_slice(slice)
    by_track = by_tracking_no(slice.pluck(:tracking_no))
    slice.each do |record|
      detail = by_track[record[:tracking_no].to_i]
      populate(record, detail)
      detail.save
    end
  end

  def populate(record, detail)
    detail.attributes = {
      tracking_no: parse_int(record[:tracking_no]),
      employee_number: parse_int(record[:emp_no]),
      employee_name: parse_string(record[:emp_name]),
      employee_rank: parse_int(record[:emp_rank]),
      customer_number: parse_int(record[:customer_no]),
      customer_name: parse_string(record[:customer_name]),
      street_no: parse_string(record[:street_no]),
      street: parse_string(record[:street]),
      xstreet: parse_string(record[:xstreet]),
      start_date_time: parse_detail_time(record[:start_date], record[:start_time]),
      end_date_time: parse_detail_time(record[:end_date], record[:end_time]),
      minutes_worked: parse_hours_worked(record[:hours_worked]),
      detail_type: parse_string(record[:detail_type]),
      pay_hours: parse_int(record[:pay_hours]),
      pay_amount: parse_int(record[:pay_amount]),
      pay_rate: parse_int(record[:pay_rate]),
      officer: @by_employee_id[parse_int(record[:emp_no])]
    }
    detail.add_attribution(attribution)
  end

  def parse_detail_time(date, time)
    Time.strptime("#{date} #{time}", "%d-%b-%y %H%M").strftime("%F %T")
  end

  def parse_hours_worked(hours_worked)
    hours = hours_worked[0..1].to_i
    minutes = hours_worked[2..3].to_i
    hours*60 + minutes
  end

  def by_tracking_no(tracking_nos)
    by_tracking_no = Hash.new { |h,k| h[k] = Detail.new }
    by_tracking_no.merge!(
      Detail.where(tracking_no: tracking_nos)
        .index_by(&:tracking_no)
    )
    by_tracking_no
  end
end
