class CitationOffense
  include ActiveModel::Model

  FIELDS = [
    :offense, :description, :assessment, :expected_assessment,
    :display_assessment, :disposition, :disposition_description, :major_incident,
    :surchargeable, :sdip_points
  ]

  FIELDS.each { |f| attr_accessor f }

  def attributes
    FIELDS.inject({}) do |h,f|
      h[f.to_s] = self.send(f)
      h
    end.compact
  end

  def ==(o)
    o.class == self.class && o.attributes == self.attributes
  end
  alias_method :eql?, :==

  def hash
    attributes.hash
  end
end
