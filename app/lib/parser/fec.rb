# parser for FEC contributions data from:
# https://www.fec.gov/data/receipts/individual-contributions
class Parser::Fec < Parser::Csv
  def category
    "fec"
  end
end
