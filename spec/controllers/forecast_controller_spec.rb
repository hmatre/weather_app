require 'rails_helper'

RSpec.describe ForecastController, type: :controller do
  describe 'GET #index' do
    it 'retrieves forecast data and renders the index template' do
      allow(ForecastService).to receive(:get_forecast).and_return({
        temperature: 20,
        high_temp: 25,
        low_temp: 15,
        extended_forecast: [],
        from_cache: false
      })

      get :index, params: { address: 'Indore, Madhya Pradesh' }

      expect(assigns(:address)).to eq('Indore, Madhya Pradesh')
      expect(assigns(:forecast)).to be_a(Hash)
      expect(response).to render_template :index
    end

    it 'handles errors when forecast data is not available' do
      allow(ForecastService).to receive(:get_forecast).and_return(nil)
      get :index, params: { address: 'Invalid Address' }
      expect(assigns(:error_message)).to eq("Could not retrieve forecast for that address.")
      expect(response).to render_template :index
    end

    it 'handles errors when empty address' do
      allow(ForecastService).to receive(:get_forecast).and_return(nil)
      get :index, params: { address: nil }

      expect(assigns(:empty_address)).to eq("Please enter address.")
      expect(response).to render_template :index
    end
  end
end
