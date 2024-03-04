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
    weather: vector<Weather>,
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

  public fun assert_is_owner(addr: address) {
    assert!(addr == @mtaptos_addr, ERR_NOT_ADMIN);
  }

  public fun assert_uninitialized(addr: address) {
    assert!(exists<WeatherForecast>(addr), ERR_NOT_INITIALIZED);
  } 

  fun init_module(account: &signer) {
    let addr = signer::address_of(account);
    assert_is_owner(addr);
    let weather_forecast = WeatherForecast {
      possible_weather: table::new(),
      weather: vector::empty<Weather>()
    };
    move_to(account, weather_forecast);
  }

  /*
    Create possible weather table
  */
  public fun create_initial_weather(account: &signer, _weather: Weather) acquires WeatherForecast {
    let addr = signer::address_of(account);
    assert_is_owner(addr);
    assert_uninitialized(@mtaptos_addr);
    let weather_forecast = borrow_global_mut<WeatherForecast>(@mtaptos_addr);
    let weather = Weather {
      id: _weather.id,
      time: _weather.time,
      name: _weather.name,
      low_temp: _weather.low_temp,
      high_temp: _weather.high_temp,
      precipitation: _weather.precipitation,
      wind_strength: _weather.wind_strength,
      wind_direction: _weather.wind_direction,
      next: _weather.next,
    };
    table::upsert(&mut weather_forecast.possible_weather, _weather.id, weather);
    vector::push_back(&mut weather_forecast.weather, weather);
  }

  /*
    Generate new weather conditions from possible weather conditions
  */
  public fun create_weather(_weather: Weather) acquires WeatherForecast {
    assert_uninitialized(@mtaptos_addr);
    let weather_forecast = borrow_global_mut<WeatherForecast>(@mtaptos_addr);
    let total_weather = vector::length(&weather_forecast.weather);
    let last_weather = *vector::borrow(&weather_forecast.weather, total_weather);
    let next_weather_length = vector::length(&mut last_weather.next);
    let next_index = randomness::u64_range(0, next_weather_length);
    let next_weather_ids = last_weather.next;
    let next_weather_id = *vector::borrow(&next_weather_ids, next_index);
    let next_weather_details = table::borrow_mut(&mut weather_forecast.possible_weather, next_weather_id);
    let time = timestamp::now_microseconds();
    let weather = Weather {
      id: total_weather+1,
      time: time,
      name: next_weather_details.name,
      low_temp: next_weather_details.low_temp,
      high_temp: next_weather_details.high_temp,
      precipitation: next_weather_details.precipitation,
      wind_strength: next_weather_details.wind_strength,
      wind_direction: next_weather_details.wind_direction,
      next: next_weather_details.next,
    };
    vector::push_back(&mut weather_forecast.weather, weather);
  }
  
}
