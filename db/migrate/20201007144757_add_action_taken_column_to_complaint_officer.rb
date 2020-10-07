class AddActionTakenColumnToComplaintOfficer < ActiveRecord::Migration[6.0]
  def change
    add_column :complaint_officers, :action_taken, :string, default: nil
  end
end
