# ===================================================================================
#     Print a list of location names, sorted by weekly revenue in descending order
# ===================================================================================
# => Read from locations.json and customers.json files.
# => The plan attribute on a customer is the number of leafy green packs
#    that they receive each week. Each pack costs $5.
# => Do not count customers with status "unsubscribed" towards revenue.
# => Feel free to use any library you'd like.
require 'json'

locations = File.read('locations.json')
locations = JSON.parse(locations)

customers = File.read('customers.json')
customers = JSON.parse(customers)

# Do not include customers with status "unsubscribed".
customers = customers.select{|customer| customer['status'] != 'unsubscribed'}

# Calculate weekly revenue at $5 per pack.
locations.each do |location|
  weekly_revenue = customers.select{|customer| customer['location_id'] == location['id']}
                            .map {|customer| customer['plan'] * 5}
                            .reduce(:+)
  $stdout.puts "#{location['name']}: $#{weekly_revenue}"
end
