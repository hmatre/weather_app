class ForecastController < ApplicationController
  CACHE_DURATION = 30.minutes

  def index
    @address = params[:address]
    if @address.present?
      @forecast = ForecastService.get_forecast(@address)

      if @forecast
        @from_cache = @forecast[:from_cache]
        @temperature = @forecast[:temperature]
        @high_temp = @forecast[:high_temp]
        @low_temp = @forecast[:low_temp]
      else
        @error_message = "Could not retrieve forecast for that address."
      end
    else
      @empty_address = "Please enter address."
    end
  end
end
