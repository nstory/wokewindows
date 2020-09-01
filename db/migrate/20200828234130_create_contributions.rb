class CreateContributions < ActiveRecord::Migration[6.0]
  def change
    create_table :contributions do |t|
      t.string :type
      t.string :date
      t.string :contributor
      t.integer :zip
      t.string :employer
      t.string :occupation
      t.decimal :amount
      t.string :committee_name
      t.integer :officer_id

      # ocpf
      t.integer :cpf_id
      t.string :candidate_full_name
      t.string :office_type
      t.string :district
      t.string :party_affiliation

      # fec
      t.string :committee_id
      t.string :memo_text
      t.string :receipt_type_full

      t.timestamps
    end
  end
end
