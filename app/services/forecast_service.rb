class ForecastService
  CACHE_DURATION = 30.minutes

  def self.get_forecast(address)
    new(address).get_forecast
  end

  def initialize(address)
    @address = address
  end

  def get_forecast
    forecast = fetch_forecast(@address)
    if forecast
      {
        from_cache: forecast[:from_cache],
        temperature: forecast[:current_temperature],
        high_temp: forecast[:high_temperature],
        low_temp: forecast[:low_temperature],
      }
    else
      nil
    end
  end

  private

  def fetch_forecast(address)
    return nil unless address.present?

    results = Geocoder.search(address)
    return nil if results.empty?

    latitude = results.first.latitude
    longitude = results.first.longitude
    cache_key = "forecast:#{latitude},#{longitude}"

    Rails.cache.fetch(cache_key, expires_in: CACHE_DURATION) do
      forecast_data = get_weather_data(latitude, longitude)
      forecast_data[:from_cache] = false if forecast_data
      forecast_data
    end.tap do |forecast|
      forecast[:from_cache] = true if forecast
    end
  end

  def get_weather_data(latitude, longitude)
    api_key = Rails.application.credentials.weather_api_key
    api_url = "https://api.openweathermap.org/data/2.5/forecast?lat=#{latitude}&lon=#{longitude}&appid=#{api_key}&units=metric"

    begin
      response = HTTParty.get(api_url)
      if response.success?
        data = JSON.parse(response.body)
        current_temp = data['main']['temp']
        high_temp = data['main']['temp_max']
        low_temp = data['main']['temp_min']

        {
          current_temperature: current_temp,
          high_temperature: high_temp,
          low_temperature: low_temp,
        }
      else
        Rails.logger.error("Weather API Error: #{response.code} - #{response.body}")
        nil
      end
    rescue => e
      Rails.logger.error("Error fetching weather data: #{e.message}")
      nil
    end
  end
end
