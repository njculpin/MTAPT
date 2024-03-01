module weather_addr::weather {

  use aptos_framework::randomness;
  use aptos_framework::event;
  use aptos_framework::account;
  use std::signer;
  use std::timestamp; 
  use aptos_std::table::{Self, Table};

  struct WeatherForecast has key {
      weather_forecast: Table<u64, Weather>,
      set_forecast_event: event::EventHandle<Weather>,
      weather_counter: u64
  }

  struct Weather has store, drop, copy {
      id: u64,
      low_temp: u8,
      high_temp: u8,
      precipitation: u8,
      wind_strength: u8,
      wind_direction: u8,
  }

  public entry fun create_forecast(account: &signer){

    let weather_forecast = WeatherForecast {
      weather_forecast: table::new(),
      set_forecast_event: account::new_event_handle<Weather>(account),
      weather_counter: 0
    };

    let counter = 1;

    let time = timestamp::now_microseconds();

    let new_weather = Weather {
      id: time,
      low_temp: 0,
      high_temp: 0,
      precipitation: 0,
      wind_strength: 0,
      wind_direction: 0,
    };

    table::upsert(&mut weather_forecast.weather_forecast, counter, new_weather);

    move_to(account, weather_forecast);
  }

  public entry fun create_weather(account: &signer) acquires WeatherForecast {

    let signer_address = signer::address_of(account);
    assert!(exists<WeatherForecast>(signer_address), 1);

    let weather_forecast = borrow_global_mut<WeatherForecast>(signer_address);
    let last_weather = table::borrow_mut(&mut weather_forecast.weather_forecast, weather_forecast.weather_counter);

    let time = timestamp::now_microseconds();
    let time_difference = last_weather.id - time;
    let twoHoursInMicroseconds = 2 * 3600 * 1000000;
    assert!(time_difference > twoHoursInMicroseconds, 1);

    let counter = weather_forecast.weather_counter + 1;

    let temp_direction = randomness::u8_integer(1);
    let new_low = randomness::u8_range(last_weather.low_temp, last_weather.low_temp + 10);
    let new_high = randomness::u8_range(last_weather.high_temp, last_weather.high_temp + 10);
    let new_precipitation = randomness::u8_range(last_weather.precipitation - 5, last_weather.precipitation + 10);
    let new_wind_strength = randomness::u8_range(last_weather.wind_strength - 5, last_weather.wind_strength + 10);
    let new_wind_direction = randomness::u8_range(0,8);

    let new_weather = Weather {
      id: time,
      low_temp: new_low,
      high_temp: new_high,
      precipitation: new_precipitation,
      wind_strength: new_wind_strength,
      wind_direction: 0,
    };

    table::upsert(&mut weather_forecast.weather_forecast, counter, new_weather);
    weather_forecast.weather_counter = counter;

    event::emit_event<Weather>(
      &mut borrow_global_mut<WeatherForecast>(signer_address).set_forecast_event,
      new_weather,
    );

  }

}