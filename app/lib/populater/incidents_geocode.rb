class Populater::IncidentsGeocode
  def self.populate
    Incident.where("geocode_latitude IS NULL AND location_of_occurrence IS NOT NULL").find_each do |inc|
      inc.geocode!
      inc.save
    end
  end
end
