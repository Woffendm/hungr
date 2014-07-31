class Restaurant < ActiveRecord::Base
  has_many :opinions
#  require 'rubygems'
#  require 'oauth'
#  require 'json'


  def constantize(string)
    return string.downcase.gsub(/[^a-z]/i, '') 
  end



  def get_restaurants
    consumer_key = 'mI-IldCQDzoRVe6jbSyNpA'
    consumer_secret = 'pl3Ao0fXT4iA4mf2g9vTM_ud-80'
    token = '1VfCZ3flvJvJHvhJNq0la4GSEgh_W7RH'
    token_secret = 'UhA6q0YfR1g89SbhY9kKRE8yRF4'
    api_host = 'api.yelp.com'
    
    consumer = OAuth::Consumer.new(consumer_key, consumer_secret, {:site => "http://#{api_host}"})
    access_token = OAuth::AccessToken.new(consumer, token, token_secret)
    
    offset = 0
    total_restaurants = 1000
    all_restaurants = []
    
    # Retrieve all results, getting around their 20 per query limit by doing a loop with offset
    while total_restaurants > offset
      path = "/v2/search?term=restaurants&location=corvallis&offset=#{offset}"
      response = JSON.parse access_token.get(path).body
      total_restaurants = response['total']
      all_restaurants = all_restaurants + response['businesses']
      offset += 20
    end
    
    # Reject any with less than 3 reviews (probably bogus)
    all_restaurants.reject! { |restaurant| restaurant['review_count'] < 3 }
    
    # Sort all restaurants alphabetically, ignoring punctuation
    all_restaurants.sort_by! { |restaurant| constantize(restaurant['name']) }
    
    # Throw away any duplicates of the same location. In event of collision, side with more reviews
    new_all_restaurants = all_restaurants
    previous_restaurant = {'name' => ''}
    all_restaurants.each do |restaurant|
      if constantize(restaurant['name']) == constantize(previous_restaurant['name']) &&
         restaurant['location']['address'] == previous_restaurant['location']['address']
        if restaurant['review_count'] > previous_restaurant['review_count']
          new_all_restaurants.delete(previous_restaurant)
        else
          new_all_restaurants.delete(restaurant)
        end
      else
        previous_restaurant = restaurant
      end
    end
    
    new_all_restaurants
  end

  
  
  def add_new_restaurants
    restaurants = get_restaurants
    existing_restaurants = Restaurant.pluck(:name).uniq
    restaurants.each do |restaurant|
      if existing_restaurants.index(restaurant['name'])
        next
      else
        Restaurant.create(:name => restaurant['name'])
        existing_restaurants << restaurant['name']
      end
    end
  end
  
end
