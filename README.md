# Weather Forecast App

This is a Ruby on Rails application that retrieves and displays weather forecasts for a given address. It utilizes the Geocoder gem for converting addresses to coordinates and a weather API (e.g., OpenWeatherMap) for fetching forecast data.  Caching is implemented using Redis to improve performance.

## Features

*   Accepts an address as input.
*   Retrieves current temperature (and optionally high/low temperatures and an extended forecast).
*   Displays the forecast details to the user.
*   Caches forecast data for 30 minutes to reduce API calls and improve response times.
*   Indicates whether the displayed data was retrieved from the cache.

## Technologies Used

*   Ruby on Rails
*   Geocoder gem
*   HTTParty gem
*   redis-rails gem
*   OpenWeatherMap API (or your preferred weather API)
*   RSpec (for testing)
*   FactoryBot (optional, for test data)

## Installation

1.  **Clone the repository:**

    ```bash
    git clone [https://github.com/](https://github.com/)[your_github_username]/weather_forecast_app.git # Replace with your repo URL
    cd weather_forecast_app
    ```

2.  **Install dependencies:**

    ```bash
    bundle install
    ```

3.  **Configure Geocoder:**  See the [Geocoder gem documentation](https://github.com/geocoding/geocoder) for any configuration needed (e.g., API keys if using a geocoding service other than the default).

4.  **Configure Weather API:**
    *   Obtain an API key from your chosen weather provider (e.g., OpenWeatherMap).
    *   Add your API key to your Rails credentials:

        ```bash
        rails credentials:edit
        ```

        Add the following line (replace with your actual key):

        ```yaml
        weather_api_key: your_actual_api_key
        ```

5.  **Configure Redis:** Ensure Redis is installed and running.  The `redis-rails` gem usually works with default Redis settings.

6.  **Database Setup (if applicable):**  If your application uses a database (it's not strictly necessary for this example, but you might add it later), configure your `config/database.yml` file and run migrations:

    ```bash
    rails db:create
    rails db:migrate
    ```

## Usage

1.  **Start the Rails server:**

    ```bash
    rails server
    ```

2.  **Access the application:** Open your web browser and go to `http://localhost:3000` (or your server's URL).

3.  **Enter an address:** Type an address in the provided field and click "Get Forecast".

4.  **View the forecast:** The application will display the current temperature (and other forecast details if implemented).  A message will indicate if the data was retrieved from the cache.

## Testing

1.  **Run the tests:**

    ```bash
    rspec
    ```

## API Integration

This application uses a weather API to retrieve forecast data.  The provided code includes an example integration with the OpenWeatherMap API.  You can easily adapt it to use other weather APIs by modifying the `get_weather_data` method in the `ForecastService`.  Remember to consult the API documentation for your chosen provider.

## Caching

Forecast data is cached for 30 minutes using Redis.  This significantly improves performance by reducing the number of API calls. The application will indicate when data is served from the cache.

## Deployment

Follow standard Rails deployment procedures to deploy this application to your preferred hosting platform (e.g., Heroku, AWS, etc.).  Make sure to configure your environment variables (especially your API key) correctly in your production environment.

## Future Enhancements

*   Implement more detailed forecast information (e.g., hourly forecasts, weather conditions, etc.).
*   Improve error handling and user feedback.
*   Add styling and improve the user interface.
*   Implement user authentication (if needed).
*   Add background jobs for updating the cache periodically.

## Contributing

Contributions are welcome!  Please open an issue or submit a pull request.

## License

[Choose a license - e.g., MIT, GPL, etc.]