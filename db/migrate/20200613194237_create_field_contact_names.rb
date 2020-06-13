class CreateFieldContactNames < ActiveRecord::Migration[6.0]
  def change
    create_table :field_contact_names do |t|
      t.belongs_to :field_contact
      t.string :fc_num
      t.string :contact_date
      t.string :sex
      t.string :race
      t.integer :age
      t.string :build
      t.string :hair_style
      t.string :skin_tone # complexion in rms
      t.string :ethnicity
      t.string :other_clothing

      # there are only supported by mark43
      t.boolean :deceased
      t.string :license_state
      t.string :license_type
      t.boolean :frisked_searched

      t.timestamps
    end
  end
end
