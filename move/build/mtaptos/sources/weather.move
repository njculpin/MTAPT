module weather_addr::weather {

  use aptos_framework::event;
  use aptos_framework::account;
  use std::signer;
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

    let new_weather = Weather {
      id: counter,
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
    let counter = weather_forecast.weather_counter + 1;

    let new_weather = Weather {
      id: counter,
      low_temp: 0,
      high_temp: 0,
      precipitation: 0,
      wind_strength: 0,
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