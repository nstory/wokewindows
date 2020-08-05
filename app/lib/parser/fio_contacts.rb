# parse fio_contacts.csv file from
# https://github.com/jacoblurye/bpd-fio-data
class Parser::FioContacts < Parser::Csv
  def category
    "bpd_fio_data"
  end
end
