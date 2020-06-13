# helpers method used by both Importer::FieldContact and
# Importer::FieldContactName
module Importer::FieldContactHelpers
  def parse_int(value)
    (value == "NULL" || value.blank?) ? nil : value.to_i
  end

  def parse_string(value)
    (value == "NULL" || value.blank?) ? nil : value
  end

  def parse_boolean(value)
    return true if ["1", "Y"].include?(value)
    return false if ["0", "N"].include?(value)
    nil
  end
end
