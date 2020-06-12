class Compensation < ApplicationRecord
  belongs_to :officer, optional: true

  # import_earnings(LoadEmployeeEarningsReport.all_with_year)
  def self.import_earnings(earnings)
    earnings.select { |e| /Boston Police/ =~ e[:department] }
      .each do |earning|
      Compensation.create({
        name: earning[:name],
        department_name: earning[:department],
        title: earning[:title],
        regular: parse_money(earning[:regular]),
        retro: parse_money(earning[:retro]),
        other: parse_money(earning[:other]),
        overtime: parse_money(earning[:overtime]),
        injured: parse_money(earning[:injured]),
        detail: parse_money(earning[:detail]),
        quinn: parse_money(earning[:quinn]),
        total: parse_money(earning[:total]),
        postal: earning[:postal].to_i,
        year: earning[:year]
      })
    end
  end

  private
  def self.parse_money(money)
    money = money.gsub(/[^\d.]/, "")
    if /^\d+\.\d\d$/ =~ money
      money.to_f
    else
      0
    end
  end
end
