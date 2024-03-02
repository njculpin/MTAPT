module mtaptos_addr::main {

  use aptos_framework::randomness;
  use aptos_std::table::{Self, Table};
  use std::signer;
  use std::string::{String};
  use std::timestamp;
  use std::vector;
  

  const ERR_NOT_INITIALIZED: u64 = 1;
  const ERR_NOT_ADMIN: u64 = 1;

  struct WeatherForecast has key {
    possible_weather: Table<u64, Weather>,
    weather: Table<u64, Weather>,
    counter: u64
  }

  struct Weather has store, drop, copy {
    id: u64,
    time: u64,
    name: String,
    low_temp: u8,
    high_temp: u8,
    precipitation: u8,
    wind_strength: u8,
    wind_direction: u8,
    next: vector<u64>,
  }

  fun init_module(account: &signer) {
    assert!(signer::address_of(account) == @mtaptos_addr, ERR_NOT_ADMIN);
    let weather_forecast = WeatherForecast {
      possible_weather: table::new(),
      weather: table::new(),
      counter: 0
    };
    move_to(account, weather_forecast);
  }

  public fun create_initial_weather(account: &signer, _weather: Weather) acquires WeatherForecast {
    assert!(signer::address_of(account) == @mtaptos_addr, ERR_NOT_ADMIN);
    assert!(exists<WeatherForecast>(@mtaptos_addr), ERR_NOT_INITIALIZED);
    let weather_forecast = borrow_global_mut<WeatherForecast>(@mtaptos_addr);
    let counter = weather_forecast.counter + 1;
    weather_forecast.counter = counter;
    let weather = Weather {
      id: counter,
      time: _weather.time,
      name: _weather.name,
      low_temp: _weather.low_temp,
      high_temp: _weather.high_temp,
      precipitation: _weather.precipitation,
      wind_strength: _weather.wind_strength,
      wind_direction: _weather.wind_direction,
      next: _weather.next,
    };
    table::upsert(&mut weather_forecast.possible_weather, counter, weather);
    table::upsert(&mut weather_forecast.weather, counter, weather);
  }

  public fun create_weather(_weather: Weather) acquires WeatherForecast {
    assert!(exists<WeatherForecast>(@mtaptos_addr), ERR_NOT_INITIALIZED);
    // Get last weather condition
    let weather_forecast = borrow_global_mut<WeatherForecast>(@mtaptos_addr);
    let next_weather = table::borrow_mut(&mut weather_forecast.weather, weather_forecast.counter);
    // Get a random ID from next weather vector
    let next_weather_length = vector::length(&mut next_weather.next);
    let next_index = randomness::u64_range(0, next_weather_length-1);
    let next_weather_ids = next_weather.next;
    let next_weather_id = *vector::borrow(&next_weather_ids, next_index);
    // Get the weather condition with that ID from possible weather
    let next_weather_details = table::borrow_mut(&mut weather_forecast.possible_weather, next_weather_id);
    // Increment the ID
    let counter = weather_forecast.counter + 1;
    let time = timestamp::now_microseconds();
    // Save new weather
    let weather = Weather {
      id: counter,
      time: time,
      name: next_weather_details.name,
      low_temp: next_weather_details.low_temp,
      high_temp: next_weather_details.high_temp,
      precipitation: next_weather_details.precipitation,
      wind_strength: next_weather_details.wind_strength,
      wind_direction: next_weather_details.wind_direction,
      next: next_weather_details.next,
    };
    table::upsert(&mut weather_forecast.weather, counter, weather);
  }

  
}
