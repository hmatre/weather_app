require 'rails_helper'

RSpec.describe ForecastService do
  let(:address) { 'Indore, Madhya Pradesh' }
  let(:latitude) { 22.7196 }
  let(:longitude) { 75.8577 }
  let(:api_key) { '' }
  let(:api_url) { "https://api.openweathermap.org/data/2.5/forecast?lat=#{latitude}&lon=#{longitude}&appid=#{api_key}&units=metric" }

  before do
    Geocoder.configure(:lookup => :test)
    Geocoder::Lookup::Test.add_stub(
      address,
      [
        {
          'latitude'  => latitude,
          'longitude' => longitude
        }
      ]
    )

    stub_request(:get, api_url).
      with(headers: {'Accept'=>'*/*'}).
      to_return(status: 200, body: File.read("spec/fixtures/open_weather_response.json"), headers: {'Content-Type': 'application/json'})

    Rails.cache.clear
  end

  it 'returns forecast data for a valid address' do
    forecast = ForecastService.get_forecast(address)

    expect(forecast).to be_a(Hash)
    expect(forecast[:temperature]).to be_present
    expect(forecast[:high_temp]).to be_present
    expect(forecast[:low_temp]).to be_present
  end

  it 'returns nil for an invalid address' do
    Geocoder::Lookup::Test.reset
    Geocoder::Lookup::Test.add_stub(
      'Invalid Address',
      []
    )
    forecast = ForecastService.get_forecast('Invalid Address')
    expect(forecast).to be_nil
  end

  it 'retrieves forecast from cache on subsequent calls' do
    ForecastService.get_forecast(address)

    forecast = ForecastService.get_forecast(address)
    expect(forecast[:from_cache]).to be true
  end

  it 'handles weather API errors' do
    stub_request(:get, api_url).to_return(status: 500, body: '{"error": "API Error"}')
    forecast = ForecastService.get_forecast(address)
    expect(forecast).to be_nil
  end

end