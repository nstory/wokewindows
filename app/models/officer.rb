class Officer < ApplicationRecord
  has_many :compensations

  # imports officer information produced by LoadDistrictJournal
  def self.import_from_journal_records(records)
    # creates array of arrays [[123, "NAME"], ...]
    officer_records = records.pluck(:officer)
      .select { |o| /^\d{4,}  / =~ o } # all employee ids are at-least 4 digits
      .map { |o| [o.to_i, o.sub(/^\d+  /, "")] }

    # {123456 => {"NAME" => 1}}
    grouped_id_name_count = officer_records.group_by(&:first)
      .map { |k,v| [k, v.group_by(&:second).map { |vk,vv| [vk, vv.count] }.to_h] }
      .to_h

    # {123456 => "NAME"} where NAME is the most popular name for that id
    id_to_name = grouped_id_name_count.map { |k,v| [k, v.max_by(&:second).first] }.to_h

    id_to_name.each do |id,name|
      officer = Officer.find_or_create_by(employee_id: id)
      officer.journal_name = name
      officer.save
    end
  end

  # imports officer information from LoadCsv parsing CY2015_Annual_Earnings_BPD.csv
  def self.import_from_bpd_annual_earnings(records)
    records.each do |record|
      officer = Officer.find_or_create_by(employee_id: record[:empl_id])
      if !officer.hr_name
        officer.hr_name = record[:name]
        officer.save
      end
    end
  end

  # imports officer information from LoadCsv parsing ALPHa_LISTING_BPD_with_badges_1.csv
  def self.import_from_alpha_listing(records)
    records.each do |record|
      officer = Officer.find_or_create_by(employee_id: record[:idno6])
      if !officer.hr_name
        officer.hr_name = record[:name]
        officer.save
      end

      if !officer.doa
        officer.doa = convert_date(record[:doa])
        officer.save
      end
    end
  end

  def self.populate_hr_names_using_compensations
    Officer.where("hr_name IS NULL").each do |officer|
      comps = rotated_likes(officer[:journal_name]).inject(Compensation.where("0=1")) do |q,l|
        q.or(Compensation.where("name LIKE ?", l))
      end.to_a
      if !comps.empty?
        # do not use this name if the query matched multiple names in the
        # same year. in that case we really don't know who this is.
        years = comps.pluck(:year)
        if years == years.uniq
          officer.hr_name = comps.first.name
          officer.save
        end
      end
    end
  end

  def self.populate_hard_coded_hr_names
    hard_coded = {
      148251 => "Connolly,John Joseph",
      148289 => "OBrien,Sean Patrick",
      153086 => "Fullam Jr,Daniel J",
      144429 => "Callahan,John R",
      148319 => "Kearney,Philip Joseph",
      144310 => "Santos,Jonathan Fernandes",
      153083 => "Harrington,Brian Ford",
      144324 => "Avila,Mariana Victoria",
      153084 => "Giblin,Gerard Majella",
      156394 => "Crespo Florez,Juan Pablo",
      144487 => "Villanueva,Jason R",
      148310 => "Verderico Jr.,James Anthony",
      122785 => "De Silva,Cristian",
      144333 => "Walsh,Michael D",
      110128 => "DaSilva,Moses Jose",
      153146 => "Wells,Jordan",
      153076 => "O'Toole,Terrence vincent",
      151189 => "Agudelo-Echevarr,Marilyn",
      141503 => "Hassan McDaid,Sarah-Jane",
      144500 => "McCarthy,Sean M",
      153126 => "Guerini III,Andrew J",
      127128 => "McGarty Jr.,Paul Christopher",
      148318 => "Garcia,Maykol V",
      81203 => "O'Sullivan,David P.",
      113896 => "Hamilton,Christopher",
      103384 => "Gannon,Sean",
      10744 => "Williams,David C.",
      148274 => "Jean,Jean Michel",
      144472 => "Murphy,Sean M",
      113322 => "Nguyen,Jimmy",
      113561 => "Parlon,William",
      126186 => "O'Brien,James Gerard"
    }

    hard_coded.each do |eid, hr_name|
      officer = Officer.find_by employee_id: eid
      if officer
        officer.hr_name = hr_name
        officer.save
      end
    end
  end

  def self.populate_compensations
    dups = dup_hr_names
    Officer.all.each do |officer|
      # bail if officer's name is ambiguous
      if !dups.include?(officer.hr_name)
        comps = Compensation.where(name: officer.hr_name)
        years = comps.pluck(:year)
        # bail if there are multiple compensations with same year and name
        if years == years.uniq
          officer.compensations = comps
          officer.save
        end
      end
    end
  end

  def self.dup_hr_names
    Officer.pluck(:hr_name).group_by(&:to_s).select {|k,v| v.count > 1}.keys
  end

  def self.rotated_likes(name)
    split = name.split(/\s+/)
    (1...split.count).map do |n|
      split.rotate(n).join("%") + "%"
    end
  end

  private
  def self.convert_date(date)
    if %r{^(\d{1,2})/(\d{1,2})/(\d{1,2})$} =~ date
      year = $3.to_i
      year += (year < 50 ? 2000 : 1900)
      "#{year}-#{$1.rjust(2, "0")}-#{$2.rjust(2, "0")}"
    else
      nil
    end
  end
end
