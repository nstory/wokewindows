class ChangeReportDateColumnOnIncident < ActiveRecord::Migration[6.0]
  def change
    change_column :incidents, :report_date, :string
  end
end
