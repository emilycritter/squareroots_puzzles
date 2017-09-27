# =====================================================================================================
#     Print a list of location names, ordered from shortest to longest driving distance from the farm
# =====================================================================================================
# => Read from locations.json and customers.json files.
# => The Square Roots farm is located at 630 Flushing Ave, Brooklyn NY 11211.
# => Feel free to use any library/API you'd like.
require 'json'
require 'google_maps_service'

class GoogleMaps
  API_KEY = 'AIzaSyADf6nbq5Vo697U1u_Pw9JsDUahM3Eyz14'

  def initialize
    @gmaps = GoogleMapsService::Client.new(
      key: API_KEY,
      retry_timeout: 20,      # Timeout for retrying failed request
      queries_per_second: 10  # Limit total request per second
    )
  end

  def get_distance (origin, destination)
    routes = @gmaps.directions(
      origin,
      destination,
      mode: 'driving',
      alternatives: false
    )
    routes ? routes[0][:legs][0][:distance] : {text: 'Unavailable', value: 0}
  end
end

begin
  # Instructions include reading from the customers.json file; however,
  # no data from customers.json is used.
  customers = File.read('customers.json')
  customers = JSON.parse(customers)

  locations = File.read('locations.json')
  locations = JSON.parse(locations)
  square_roots_farm = '630 Flushing Ave, Brooklyn NY 11211'

  # Get driving distance for each location from the farm
  gmaps = GoogleMaps.new
  locations.each {|location| location['distance'] = gmaps.get_distance(square_roots_farm, location['address'])}

  # Sort locations by driving distance from the farm (shortest to longest)
  locations_by_distance = locations.sort_by {|location| location['distance'][:value]}
                                   .map{|location| "#{location['name']}: #{location['distance'][:text]}"}
  $stdout.puts locations_by_distance

rescue StandardError => e
  puts e.message
  raise "There was an error pulling directions data from the Google Maps API"
end
