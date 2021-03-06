class Venue < ActiveRecord::Base
  include PgSearch
  pg_search_scope :search, against: [:name, :address],
                           using: {
                             tsearch: { prefix: true }
                           }

  has_many :events

  # Validators
  validates :name, presence: true
  validates :address, presence: true

  # Plugins
  geocoded_by :address do |obj, results|
    if geo = results.first
      obj.latitude     = geo.latitude
      obj.longitude    = geo.longitude
      obj.city         = geo.city
      obj.country_name = geo.country
      obj.country_code = geo.country_code

      street_number = geo.address_components.select { |s| s['types'].include? 'street_number' }.first
      street_route  = geo.address_components.select { |s| s['types'].include? 'route' }.first

      formatted_street = (street_number && street_route) ? "#{street_route['short_name']} #{street_number['short_name']}" : nil

      obj.street = formatted_street
    end
  end

  # Callbacks
  before_validation :geocode, if: :address_changed?

  # Validations
  validates :name, presence: true
  with_options if: Proc.new { |e| e.address.present? } do |geo|
    geo.validates :country_name, presence: true
    geo.validates :country_code, presence: true
    geo.validates :city, presence: true
  end

  def to_s
    "#{name} - #{street}, #{city}, #{country_name}"
  end

  def self.find_or_create_tba(city, country_code)
    fail ArgumentError, "City and country code can't be blank" if city.blank? || country_code.blank?

    venue = Venue.find_by(name: 'TBA', city: city, country_code: country_code)
    return venue if venue

    Venue.create(name: 'TBA', address: "#{city}, #{country_code}")
  end
end
