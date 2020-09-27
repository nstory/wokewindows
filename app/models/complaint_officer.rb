class ComplaintOfficer < ApplicationRecord
  belongs_to :complaint
  belongs_to :officer, optional: true

  # one of :severe, :concerning, :less_concerning
  # I made up these classifications
  def severity
    al = (allegation || "").sub(/ \(.*/, "") # remove parentheticals

    return :severe if [
      "Violation of Criminal Law",
      "Conformance to Laws"
    ].include?(al)

    return :concerning if [
      "Neg.Duty/Unreasonable Judge",
      "Respectful Treatment",
      "Conduct Unbecoming",
      "Use of Force",
      "Untruthfulness",
      "Drug Test",
      "Dir./Orders",
      "Self Identification",
      "Directives/Orders",
      "Abuse of Process",
      "Securing and Maintenance of Firearm",
      "Untruthfulness in Department Report",
      "Investigation of Use Of Force"
    ].include?(al)

    return :less_concerning
  end

  def less_concerning?
    severity == :less_concerning
  end

  def concerning?
    severity == :concerning
  end

  def severe?
    severity == :severe
  end

  def sustained?
    finding == "Sustained"
  end

  def use_of_force?
    /Use of Force/i =~ allegation
  end

  def normalized_allegation
    return nil if !allegation
    allegation.sub(/\(.+\)$/, "")
      .sub(/\d+ counts.*/i, "")
      .strip
  end
end
