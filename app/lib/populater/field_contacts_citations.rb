class Populater::FieldContactsCitations
  def self.populate
    FieldContact.find_each do |fc|
      numbers = find_ticket_numbers(fc.narrative)
      if !numbers.empty?
        citations = Citation.where(ticket_number: numbers)
        fc.citations = citations
      end
    end
  end

  private
  def self.find_ticket_numbers(narrative)
    return [] if !narrative
    narrative.scan(/\b(T\d{7}|R\d{7}|\d{6}AA)\b/i).map(&:first).map(&:upcase)
  end
end
