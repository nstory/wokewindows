class Officer < ApplicationRecord
  include Attributable
  include BagOfText

  has_many :compensations, dependent: :nullify
  has_many :complaint_officers, dependent: :nullify
  has_many :complaints, -> { distinct }, through: :complaint_officers
  has_many :incidents, dependent: :nullify
  has_many :field_contacts, foreign_key: :contact_officer_id, class_name: "FieldContact", inverse_of: :contact_officer, dependent: :nullify
  has_many :supervised_field_contacts, foreign_key: :supervisor_id, class_name: "FieldContact", inverse_of: :supervisor, dependent: :nullify
  belongs_to :zip_code, foreign_key: :postal, primary_key: :zip, optional: true
  has_many :swats_officers, dependent: :nullify
  has_many :swats, through: :swats_officers
  has_many :details, dependent: :nullify
  has_many :citations, dependent: :nullify
  has_many :articles_officers, dependent: :delete_all
  has_many :articles, through: :articles_officers
  has_many :overtimes, dependent: :nullify
  has_one :pension

  enum rank: {
    capt: "capt",
    civili: "civili",
    comiss: "comiss",
    depsup: "depsup",
    det: "det",
    lieut: "lieut",
    ltdet: "ltdet",
    ptl: "ptl",
    sergt: "sergt",
    sgtdet: "sgtdet",
    supt: "supt"
  }

  def bag_of_text_content
    [name, title, postal, zip_code && zip_code.state, zip_code && zip_code.neighborhood_or_city, organization, badge]
  end

  def last_name_regexp
    Regexp.new(hr_name.sub(/,.*/, "").gsub(/[^a-z]/i, ".?"), Regexp::IGNORECASE)
  end

  # regexp good for checking if an officer is referenced in an article
  def article_regexp
    return nil unless hr_name

    last_name, first_name = hr_name.split(",", 2)

    # remove middle initial at end
    first_name.sub!(/\b[a-z]$/i, "")

    # remove middle initial with period
    first_name.sub!(/\b[a-z]\./i, "")

    first_name.strip!

    # remove middle name if present
    first_name.sub!(/ .*/, "")
    first_name.strip!

    # a couple nicknames
    first_name = "jack|john" if first_name =~ /^john$/i
    first_name = "jim|james" if first_name =~ /^james$/i
    first_name = "patrick|pat" if first_name =~ /^patrick$/i

    Regexp.new("\\b(#{first_name})\\b.{0,5}\\b(#{last_name})\\b", Regexp::IGNORECASE)
  end

  def last_first_regexp
    return nil if !hr_name
    last_name, rest = hr_name.split(",", 2)
    first_name, middle_name = rest.split(" ", 2)
    last_name.gsub!(/\s+/, '[\s-]+')
    /\b#{last_name}\s*,\s*#{first_name}\s*(#{middle_name})?\b/i
  end

  def name
    if hr_name
      hr_name.sub(/,/, ", ")
    elsif journal_name
      journal_name.titleize
    else
      "Unknown"
    end
  end

  def first_name_last
    n = name
    if /^(.+),(.+)$/.match(n)
      return "#{$2.strip} #{$1.strip}"
    end
    n
  end

  def name_with_title
    t = rank_from_title
    n = first_name_last
    if t then "#{t} #{n}" else n end
  end

  def rank_from_title
    # special case for civilians with "Supn" in their titles
    return nil if title =~ /Supn Auto|Supn-Custodians/

    case(title)
    when /^Police Officer/
      "Officer"
    when /^Police Detectiv/
      "Detective"
    when /^Police Sergeant \(Det/
      "Sgt. Det."
    when /^Police Sergeant/
      "Sergeant"
    when /^Police Offc/
      "Officer"
    when /^Police Lieutenant \(Det/
      "Lt. Det."
    when /^Police Lieutenant/
      "Lieutenant"
    when /^Police Captain/
      "Captain"
    when /^Dep Supn/
      "Deputy Supt."
    when /^Supn/
      "Supt."
    else
      nil
    end
  end

  # use employee_id + first_name_last for resource urls
  def to_param
    slug = "#{employee_id} #{first_name_last}"
    slug.parameterize
  end

  def calculate_ia_score
    sustained_concerning = complaint_officers.select do |co|
      co.sustained? && co.concerning?
    end
    sustained_concerning_uniq_case = sustained_concerning.uniq(&:complaint)
    sustained_less_concerning = complaint_officers.select do |co|
      co.sustained? && co.less_concerning?
    end

    # 5 if 1 severe case or 5 concerning cases
    return 5 if complaint_officers.any? do |c|
      c.sustained? && c.severe?
    end
    return 5 if sustained_concerning_uniq_case.count >= 5

    # 4 if 2 concerning cases or 1 use of force
    return 4 if sustained_concerning_uniq_case.count >= 2
    return 4 if sustained_concerning.any? { |co| co.use_of_force? }

    # 3 if one concerning case
    return 3 if sustained_concerning_uniq_case.count >= 1

    # 2 if one sustained less-concerning case or 5 cases regardless of finding
    return 2 if sustained_less_concerning.count >= 1
    return 2 if complaint_officers.uniq(&:complaint).count >= 5

    # 1 if >= 2 cases regardless of finding
    return 1 if complaint_officers.uniq(&:complaint).count >= 2

    # 0 if <= 1 cases and no sustained finding
    return 0
  end

  def articles_officers_to_review_count
    articles_officers.count { |ao| ao.status == "added" }
  end

  def ia_sustained_conduct_unbecoming
    sustained_complaints(/Conduct Unbecoming/i)
  end

  def ia_sustained_neg_duty
    sustained_complaints(/Neg.Duty|Neglect of Duty|Unreasonable Judge/i)
  end

  def ia_sustained_respectful_treatment
    sustained_complaints(/Respectful Treatment/i)
  end

  def ia_sustained_self_identification
    sustained_complaints(/Self Identification/i)
  end

  def ia_sustained_use_of_force
    sustained_complaints(/Use of Force/i)
  end

  def ia_sustained_law_breaking
    sustained_complaints(/Violation of Criminal Law|Conformance to Laws|Criminal Complaints/i)
  end

  def ia_sustained_details
    sustained_complaints(/Details|Detail Assignment|Detail Cards|Paid Detail Assignment/)
  end

  def ia_sustained_untruthfulness
    sustained_complaints(/Untruthfulness/i)
  end

  def ia_sustained_complaints
    sustained_complaints(/./)
  end

  def ia_sustained_allegations
    complaint_officers.select { |co| co.finding == "Sustained" }
  end

  def ia_complaints
    complaints.select do |c|
      c.is_internal_investigation? || c.is_citizen_complaint?
    end
  end

  def ia_allegations
    complaint_officers.select do |co|
      co.complaint.is_internal_investigation? || co.complaint.is_citizen_complaint?
    end.count
  end

  def years_of_service
    return nil if !doa
    hired = Date.strptime(doa, "%F")
    days = (Date.current - hired).to_i
    days / 365
  end

  def latest_compensation
    compensations.max_by(&:year)
  end

  def self.by_employee_id
    Officer.find_each.index_by(&:employee_id)
  end

  def self.fix_ia_score
    Officer.includes(complaint_officers: [:complaint]).find_each do |o|
      o.ia_score = o.calculate_ia_score
      o.save
    end
  end

  private
  # unique complaints against this officer where at least one allegation
  # matches regexp
  def sustained_complaints(regexp)
    complaint_officers.select do |co|
      co.allegation =~ regexp && co.finding == "Sustained"
    end.map(&:complaint).uniq
  end
end
