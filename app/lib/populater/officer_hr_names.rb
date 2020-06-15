# populates the hr_name for officers by fuzzy matching their journal_name
# (derived from incident reports) with the compensations table (derived
# from city earnings reports)
class Populater::OfficerHrNames
  def self.populate
    populate_hard_coded
    populate_using_compensations
  end

  private
  def self.populate_hard_coded
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
      126186 => "O'Brien,James Gerard",
      116134 => "Defay,Claude N",
      144313 => "Andrade,Manuel",
      131224 => "Stemn,Anthony H",
      148252 => "Connor,Robert Keith",
      129442 => "Burke,Sean C",
      144421 => "Burke,Sean"
    }

    Officer.transaction do
      Officer.where(employee_id: hard_coded.keys).each do |o|
        o.hr_name = hard_coded[o.employee_id]
        o.save
      end
    end
  end

  def self.populate_using_compensations
    names = all_names - duplicate_names
    Officer.transaction do
      Officer.where("hr_name IS NULL AND journal_name IS NOT NULL").each do |officer|
        re = rotations_regexp(officer.journal_name)
        matching_names = names.select { |name| re =~ name }
        if matching_names.count == 1
          officer.hr_name = matching_names.first
          officer.save
        end
      end
    end
  end

  # names that appear twice in any year in our compensations
  # table. this means the name is ambiguous and we can't use
  # it for matching
  def self.duplicate_names
    Compensation.connection.select_all('select year, name, count(*) as count from compensations group by year, name having count > 1').pluck("name").uniq
  end

  def self.all_names
    Compensation.connection.select_all('select name from compensations group by name').pluck("name").uniq
  end

  def self.rotations_regexp(name)
    split = name.downcase.gsub(/[^a-z ]/, ".*").split(/ +/)
    exps = (0...split.count).map do |n|
      split.rotate(n).join(".+") + ".*"
    end
    Regexp.new("^(#{exps.join('|')})$", Regexp::IGNORECASE)
  end
end
