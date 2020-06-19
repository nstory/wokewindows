# populate search_frisked field; if any individual was searched, set
# field to true
class Populater::FieldContacts
  def self.populate
    FieldContact.includes(:field_contact_names).find_in_batches do |group|
      FieldContact.transaction do
        group.each do |fc|
          populate_field_contact(fc)
        end
      end
    end
  end

  private
  def self.populate_field_contact(fc)
    fc.frisked_searched ||= fc.field_contact_names.any?(&:frisked_searched)
    fc.save
  end
end
