# import fio_people.csv file from
# https://github.com/jacoblurye/bpd-fio-data
class Parser::FioPeople < Parser::Csv
  def category
    "bpd_fio_data"
  end
end
