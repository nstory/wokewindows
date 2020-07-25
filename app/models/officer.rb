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

  def bag_of_text_content
    [name, title, postal, zip_code && zip_code.state, zip_code && zip_code.neighborhood]
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

    Regexp.new("\\b(#{first_name})\\b.{0,5}\\b(#{last_name})\\b", Regexp::IGNORECASE)
  end

  def last_first_regexp
    return nil if !hr_name
    Regexp.new(name.gsub(/[^a-z]+/i, ".*"), Regexp::IGNORECASE)
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

  # use employee_id for resource urls
  def to_param
    employee_id.to_s
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

    # 4 if 2 concerning cases
    return 4 if sustained_concerning_uniq_case.count >= 2

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

  def self.by_employee_id
    Officer.find_each.index_by(&:employee_id)
  end

  def self.fix_ia_score
    Officer.includes(complaint_officers: [:complaint]).find_each do |o|
      o.ia_score = o.calculate_ia_score
      o.save
    end
  end
end
