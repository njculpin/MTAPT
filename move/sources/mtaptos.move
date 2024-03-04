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
  public fun create_initial_weather(
    account: &signer,
    _id: u64,
    _name: String,
    _low_temp: u8,
    _high_temp: u8,
    _precipitation: u8,
    _wind_strength: u8,
    _wind_direction: u8,
    _next: vector<u64>
    ) acquires WeatherForecast {

    let addr = signer::address_of(account);
    assert_is_owner(addr);
    assert_uninitialized(@mtaptos_addr);

    let weather_forecast = borrow_global_mut<WeatherForecast>(@mtaptos_addr);
    let weather = Weather {
      id: _id,
      name: _name,
      low_temp: _low_temp,
      high_temp: _high_temp,
      precipitation: _precipitation,
      wind_strength: _wind_strength,
      wind_direction: _wind_direction,
      next: _next,
    };

    table::upsert(&mut weather_forecast.possible_weather, _id, weather);
    vector::push_back(&mut weather_forecast.weather, weather);
  }

  /*
    Create initial forecast
  */
  public fun create_initial_forecast() acquires WeatherForecast {
    assert_uninitialized(@mtaptos_addr);

    let weather_forecast = borrow_global_mut<WeatherForecast>(@mtaptos_addr);
    let next_weather_details = table::borrow_mut(&mut weather_forecast.possible_weather, 0);
    let time = timestamp::now_microseconds();

    let weather = Weather {
      id: time,
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
      id: time,
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

  #[test(owner=@0x123,to=@0x768)]
  fun test_weather(admin: signer,to: signer) acquires WeatherForecast {

    init_module(&admin);

    let first = create_initial_weather(
      admin,
      1,
      b"Partly Cloudy",
      50,
      65,
      100,
      2,
      4,
      vector<u64>[ 2, 3 ],
      );

    let second = create_initial_weather(
      admin,
      2,
      b"Sunny",
      50,
      65,
      100,
      2,
      4,
      vector<u64>[ 1, 3 ],
      );

    let third = create_initial_weather(
      admin,
      3,
      b"Scattered Showers",
      50,
      65,
      100,
      2,
      4,
      vector<u64>[ 2 ],
      );

    create_initial_forecast(admin)
  }
  
}
