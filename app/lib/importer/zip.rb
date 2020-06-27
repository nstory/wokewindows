class Importer::Zip < Importer::Importer
  SLICE = 1000

  def self.import_all
    parser = Parser::Zip.new("data/zipcode.csv.gz")
    new(parser).import
  end

  def import
    records.each_slice(SLICE) do |slice|
      ZipCode.transaction do
        slice.each { |record| import_record(record) }
      end
    end
  end

  def import_record(record)
    ZipCode.insert({
      zip: record[:zip],
      city: record[:city],
      state: record[:state],
      latitude: record[:latitude],
      longitude: record[:longitude],
      created_at: Time.now,
      updated_at: Time.now
    })
  end
end
