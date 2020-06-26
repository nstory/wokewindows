class ZipCode < ApplicationRecord
  TABLE = {
    2134=>"Allston/Brighton", 2135=>"Allston/Brighton",
    2163=>"Allston/Brighton", 2108=>"Back Bay/Beacon Hill",
    2116=>"Back Bay/Beacon Hill", 2117=>"Back Bay/Beacon Hill",
    2199=>"Back Bay/Beacon Hill", 2217=>"Back Bay/Beacon Hill",
    2133=>"Back Bay/Beacon Hill", 2109=>"Central Boston",
    2110=>"Central Boston", 2111=>"Central Boston",
    2112=>"Central Boston", 2113=>"Central Boston",
    2114=>"Central Boston", 2196=>"Central Boston",
    2201=>"Central Boston", 2203=>"Central Boston",
    2205=>"Central Boston", 2211=>"Central Boston",
    2212=>"Central Boston", 2222=>"Central Boston",
    2241=>"Central Boston", 2283=>"Central Boston",
    2297=>"Central Boston", 2129=>"Charlestown",
    2122=>"Dorchester", 2124=>"Dorchester",
    2125=>"Dorchester", 2128=>"East Boston",
    2228=>"East Boston", 2115=>"Fenway/Kenmore",
    2215=>"Fenway/Kenmore", 2123=>"Fenway/Kenmore",
    2136=>"Hyde Park", 2137=>"Hyde Park",
    2130=>"Jamaica Plain", 2126=>"Mattapan",
    2131=>"Roslindale", 2119=>"Roxbury",
    2120=>"Roxbury", 2121=>"Roxbury",
    2127=>"South Boston", 2210=>"South Boston",
    2118=>"South End", 2132=>"West Roxbury",
    2204 => "Central Boston", 2206 => "Central Boston",
    2266 => "Central Boston", 2284 => "Central Boston",
    2293 => "Central Boston", 2298 => "South Boston"
  }

  def neighborhood
    TABLE.fetch(zip, city)
  end
end
