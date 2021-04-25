# roll up some values from associations into Officer
class Populater::Officers
  def self.populate
    query = Officer.includes(:compensations, :complaints)
    query.find_in_batches do |group|
      Officer.transaction do
        group.each do |officer|
          populate_officer(officer)
        end
      end
    end

    populate_earnings_ranks
  end

  private
  def self.populate_officer(officer)
    latest_comp = officer.compensations.max_by(&:year)
    if latest_comp
      officer.title = latest_comp.title
      officer.postal = latest_comp.postal
    end

    last_year_comp = officer.compensations.find { |c| c.year == Rails.configuration.last_year }
    if last_year_comp
      officer.regular = last_year_comp.regular
      officer.retro = last_year_comp.retro
      officer.other = last_year_comp.other
      officer.overtime = last_year_comp.overtime
      officer.injured = last_year_comp.injured
      officer.detail = last_year_comp.detail
      officer.quinn = last_year_comp.quinn
      officer.total = last_year_comp.total
    end

    officer.complaints_count = officer.complaints.size

    officer.save
  end

  private
  def self.populate_earnings_ranks
    query = Officer.where.not(total: nil).order(total: :desc)
    Officer.transaction do
      query.each_with_index do |officer, index|
        if officer.total
          officer.earnings_rank = index + 1
          officer.save
        end
      end
    end
  end
end
