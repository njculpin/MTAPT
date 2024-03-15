module basecamp::main {

  use aptos_framework::account;
  use aptos_framework::event;
  use aptos_framework::object;
  use aptos_framework::randomness;
  use aptos_framework::object::ExtendRef;
  use aptos_std::string_utils::{to_string};
  use aptos_std::table::{Self, Table}; 
  use std::option;
  use std::vector;
  use std::signer::address_of;
  use std::string::{String, utf8};
  use aptos_token_objects::collection;
  use aptos_token_objects::token;

  const APP_OBJECT_SEED: vector<u8> = b"BASECAMP";
  const BASECAMP_COLLECTION_NAME: vector<u8> = b"Basecamp Collection";
  const BASECAMP_COLLECTION_DESCRIPTION: vector<u8> = b"Basecamp Collection Description";
  const BASECAMP_COLLECTION_URI: vector<u8> = b"png";
  const MAX_CREW: u8 = 10;
  const MAP_SIZE: u64 = 100;

  const ERR_NOT_INITIALIZED: u64 = 1;
  const ERR_NOT_ADMIN: u64 = 2;
  const ERR_MAX_CREW: u64 = 3;
  const ERR_CREW_NOT_HOME: u64 = 4;
  const ERR_BASECAMP_MISSING: u64 = 5;
  const ERR_BASECAMP_DEAD: u64 = 6;
  const ERR_MOVE_TOO_FAR: u64 = 7;

  struct Crew has store, drop, copy {
    live: bool,
    health: u8,
    strength: u8,
    endurance: u8,
    intelligence: u8,
    perception: u8,
    speed: u8,
    lat: u64,
    long: u64
  }

  struct Weather has store, drop, copy {
    temp: u8,
    rain: u8,
    wind: u8,
  }

  struct Basecamp has key {
    live: bool,
    gold: u8,
    weather: Weather,
    crew: Table<u64, Crew>,
    crew_count: u64,
    lat: u64,
    long: u64,
    world: Table<u64, Position>,
    extend_ref: ExtendRef,
    mutator_ref: token::MutatorRef,
    burn_ref: token::BurnRef,
  }

  struct Discovery has store, drop, copy {
    name: vector<u8>,
    gold_value: u8,
    damage_radius: u8,
    improvement_radius: u8,
    health_damage: u8,
    health_improvement: u8,
    strength_damage: u8,
    strength_improvement: u8,
    endurance_damage: u8,
    endurance_improvement: u8,
    intelligence_damage: u8,
    intelligence_improvement: u8,
    perception_damage: u8,
    perception_improvement: u8,
    speed_damage: u8,
    speed_improvement: u8
  }

  struct Position has store, drop, copy {
    discoveries: vector<Discovery>,
    lat: u64,
    long: u64,
  }

  // collection signer
  struct CollectionCapability has key {
    extend_ref: ExtendRef,
  }

  struct MintBasecampEvents has key {
    mint_basecamp_events: event::EventHandle<MintBasecampEvent>,
  }

  struct MintBasecampEvent has drop, store {
    basecamp_address: address,
    token_name: String,
  }

  public fun assert_uninitialized(addr: address) {
    assert!(exists<Basecamp>(addr), ERR_NOT_INITIALIZED);
  } 

  fun init_module(account: &signer) {
    let constructor_ref = object::create_named_object(
        account,
        APP_OBJECT_SEED,
    );
    let extend_ref = object::generate_extend_ref(&constructor_ref);
    let app_signer = &object::generate_signer(&constructor_ref);
    move_to(account, MintBasecampEvents {
        mint_basecamp_events: account::new_event_handle<MintBasecampEvent>(account),
    });
    move_to(app_signer, CollectionCapability {
        extend_ref,
    });
    
    create_basecamp_collection(app_signer);
  }

  fun get_collection_address(): address {
    object::create_object_address(&@basecamp, APP_OBJECT_SEED)
  }

  fun get_collection_signer(collection_address: address): signer acquires CollectionCapability {
        object::generate_signer_for_extending(&borrow_global<CollectionCapability>(collection_address).extend_ref)
    }

  fun get_basecamp_signer(basecamp_address: address): signer acquires Basecamp {
      object::generate_signer_for_extending(&borrow_global<Basecamp>(basecamp_address).extend_ref)
  }

  fun create_basecamp_collection(creator: &signer) {
    let description = utf8(BASECAMP_COLLECTION_DESCRIPTION);
    let name = utf8(BASECAMP_COLLECTION_NAME);
    let uri = utf8(BASECAMP_COLLECTION_URI);
    collection::create_unlimited_collection(
        creator,
        description,
        name,
        option::none(),
        uri,
    );
  }

  entry fun create_basecamp(user: &signer, crew_count: u8) acquires CollectionCapability, MintBasecampEvents {
    create_basecamp_internal(user, crew_count);
  }

  fun create_basecamp_internal(user: &signer, crew_count: u8): address acquires CollectionCapability, MintBasecampEvents {

    // meta
    let uri = utf8(BASECAMP_COLLECTION_URI);
    let description = utf8(BASECAMP_COLLECTION_DESCRIPTION);
    let user_address = address_of(user);
    let token_name = to_string(&user_address);
    
    // gold
    let minimum_gold = crew_count * 2;
    let maximum_gold = crew_count * 10;
    let gold = randomness::u8_range(minimum_gold, maximum_gold);

    // weather,
    let temp = randomness::u8_range(45, 95);
    let rain = randomness::u8_range(0, 100);
    let wind = randomness::u8_range(2, 75);
    let weather = Weather {
      temp: temp,
      rain: rain,
      wind: wind
    };

    // start location
    let lat = randomness::u64_range(1, 5);
    let long = randomness::u64_range(90, 95);

    // world 
    let world = table::new();
    let discoveries_count = 1;
    let discoveries = vector::empty<Discovery>();
    let position = Position {
      discoveries: discoveries,
      lat: lat,
      long: long
    };
    table::upsert(&mut world, discoveries_count, position);

    // crew,
    let crew = table::new();
    let counter = 1;
    for (i in 1..(crew_count+1)){
      let strength = randomness::u8_range(1, 5);
      let endurance = randomness::u8_range(1, 10);
      let intelligence = randomness::u8_range(2, 7);
      let perception = randomness::u8_range(2, 10);
      let speed = randomness::u8_range(1, 3);
      let crew_member = Crew {
        live: true,
        health: 5,
        strength: strength,
        endurance: endurance,
        intelligence: intelligence,
        perception: perception,
        speed: speed,
        lat: lat,
        long: long
      };
      table::upsert(&mut crew, counter, crew_member);
      counter = counter + 1
    };

    let collection_address = get_collection_address();
    let constructor_ref = &token::create(
        &get_collection_signer(collection_address),
        utf8(BASECAMP_COLLECTION_NAME),
        description,
        token_name,
        option::none(),
        uri,
    );

    let token_signer_ref = &object::generate_signer(constructor_ref);
    let basecamp_address = address_of(token_signer_ref);

    let extend_ref = object::generate_extend_ref(constructor_ref);
    let mutator_ref = token::generate_mutator_ref(constructor_ref);
    let burn_ref = token::generate_burn_ref(constructor_ref);
    let transfer_ref = object::generate_transfer_ref(constructor_ref);

    // Initialize and set default Basecamp struct values
    let basecamp = Basecamp {
        live: true,
        gold: gold,
        weather: weather,
        crew: crew,
        crew_count: counter,
        lat: lat,
        long: long,
        world: world,
        extend_ref,
        mutator_ref,
        burn_ref,
    };
    move_to(token_signer_ref, basecamp);

    // Emit event for minting Basecamp token
    event::emit_event<MintBasecampEvent>(
        &mut borrow_global_mut<MintBasecampEvents>(@basecamp).mint_basecamp_events,
        MintBasecampEvent {
            basecamp_address: address_of(token_signer_ref),
            token_name,
        },
    );

    // Transfer the Basecamp to the user
    object::transfer_with_ref(object::generate_linear_transfer_ref(&transfer_ref), address_of(user));

    basecamp_address
  }

  // CONTROLS
  fun check_basecamp_exist_and_crew_alive(basecamp_address: address) acquires Basecamp {
    let basecamp_exists = exists<Basecamp>(basecamp_address);
    assert!(basecamp_exists, ERR_BASECAMP_MISSING);
    let basecamp = borrow_global<Basecamp>(basecamp_address);
    assert!(basecamp.live, ERR_BASECAMP_DEAD);
  }

  fun crew_at_home(basecamp_address: address) acquires Basecamp {
    check_basecamp_exist_and_crew_alive(basecamp_address);
    let basecamp = borrow_global<Basecamp>(basecamp_address);
    assert!(basecamp.lat == 1, ERR_CREW_NOT_HOME);
    assert!(basecamp.long == 1, ERR_CREW_NOT_HOME);
  }

  fun rest_crew(basecamp_address: address) acquires Basecamp {
    check_basecamp_exist_and_crew_alive(basecamp_address);
    let basecamp = borrow_global<Basecamp>(basecamp_address);
    let crew_count = basecamp.crew_count;
    for (i in 1..(crew_count+1)){
      rest_crew_member(basecamp_address, i)
    };
  }

  fun rest_crew_member(basecamp_address: address, crew_id: u64) acquires Basecamp {
    check_basecamp_exist_and_crew_alive(basecamp_address);
    let basecamp = borrow_global_mut<Basecamp>(basecamp_address);
    let crew_member = table::borrow_mut(&mut basecamp.crew, crew_id);
    let new_health = clamp_value(crew_member.health + 1, 0, 5);
    crew_member.health = new_health;
  }

  fun move_crew_member(basecamp_address: address, direction: u8, distance: u64, crew_id: u64) acquires Basecamp {
    check_basecamp_exist_and_crew_alive(basecamp_address);
    if (direction == 1){
      move_crew_member_north(basecamp_address, distance, crew_id);
    };
    if (direction == 2){
      move_crew_member_east(basecamp_address, distance, crew_id);
    };
    if (direction == 3){
      move_crew_member_south(basecamp_address, distance, crew_id);
    };
    if (direction == 4){
      move_crew_member_west(basecamp_address, distance, crew_id);
    };
  }

  fun move_crew_member_north(basecamp_address: address, distance: u64, crew_id: u64) acquires Basecamp {
    let basecamp = borrow_global_mut<Basecamp>(basecamp_address);
    let crew_member = table::borrow_mut(&mut basecamp.crew, crew_id);
    assert!(crew_member.speed <= (distance as u8), ERR_MOVE_TOO_FAR);
    let new_lat = crew_member.lat - distance;
    assert!(new_lat > 0, ERR_MOVE_TOO_FAR);
    crew_member.lat = new_lat;
  }

  fun move_crew_member_east(basecamp_address: address, distance: u64, crew_id: u64) acquires Basecamp {
    let basecamp = borrow_global_mut<Basecamp>(basecamp_address);
    let crew_member = table::borrow_mut(&mut basecamp.crew, crew_id);
    assert!(crew_member.speed <= (distance as u8), ERR_MOVE_TOO_FAR);
    let new_long = crew_member.long + distance;
    assert!(new_long < MAP_SIZE, ERR_MOVE_TOO_FAR);
    crew_member.long = new_long;
  }

  fun move_crew_member_south(basecamp_address: address, distance: u64, crew_id: u64) acquires Basecamp {
    let basecamp = borrow_global_mut<Basecamp>(basecamp_address);
    let crew_member = table::borrow_mut(&mut basecamp.crew, crew_id);
    assert!(crew_member.speed <= (distance as u8), ERR_MOVE_TOO_FAR);
    let new_lat = crew_member.lat + distance;
    assert!(new_lat < MAP_SIZE, ERR_MOVE_TOO_FAR);
    crew_member.lat = new_lat;
  }

  fun move_crew_member_west(basecamp_address: address, distance: u64, crew_id: u64) acquires Basecamp {
    let basecamp = borrow_global_mut<Basecamp>(basecamp_address);
    let crew_member = table::borrow_mut(&mut basecamp.crew, crew_id);
    assert!(crew_member.speed <= (distance as u8), ERR_MOVE_TOO_FAR);
    let new_long = crew_member.long - distance;
    assert!(new_long > 0, ERR_MOVE_TOO_FAR);
    crew_member.long = new_long;
  }

  fun move_basecamp(basecamp_address: address, direction: u8) acquires Basecamp {
    // todo: if any crew members share this location,
    // move them as well.
    check_basecamp_exist_and_crew_alive(basecamp_address);
    if (direction == 1){
      move_basecamp_north(basecamp_address);
    };
    if (direction == 2){
      move_basecamp_east(basecamp_address);
    };
    if (direction == 3){
      move_basecamp_south(basecamp_address);
    };
    if (direction == 4){
      move_basecamp_west(basecamp_address);
    };
  }

  fun move_basecamp_north(basecamp_address: address) acquires Basecamp {
    let lat_ref = &mut borrow_global_mut<Basecamp>(basecamp_address).lat;
    let new_lat = *lat_ref - 1;
     assert!(new_lat > 0, ERR_MOVE_TOO_FAR);
    *lat_ref =new_lat;
  }

  fun move_basecamp_south(basecamp_address: address) acquires Basecamp {
    let lat_ref = &mut borrow_global_mut<Basecamp>(basecamp_address).lat;
    let new_lat = *lat_ref + 1;
    assert!(new_lat < MAP_SIZE, ERR_MOVE_TOO_FAR);
    *lat_ref = new_lat;
  }

  fun move_basecamp_east(basecamp_address: address) acquires Basecamp {
    let long_ref = &mut borrow_global_mut<Basecamp>(basecamp_address).long;
    let new_long = *long_ref + 1;
    assert!(new_long < MAP_SIZE, ERR_MOVE_TOO_FAR);
    *long_ref = new_long;
  }

  fun move_basecamp_west(basecamp_address: address) acquires Basecamp {
    let long_ref = &mut borrow_global_mut<Basecamp>(basecamp_address).long;
    let new_long = *long_ref - 1;
    assert!(new_long > 0, ERR_MOVE_TOO_FAR);
    *long_ref = new_long;
  }

  fun next_weather(basecamp_address: address) acquires Basecamp {
    check_basecamp_exist_and_crew_alive(basecamp_address);
    let previous_weather = &mut borrow_global_mut<Basecamp>(basecamp_address).weather;

    let temp_ref = &mut previous_weather.temp;
    let new_temp = randomness::u8_range(*temp_ref - 5, *temp_ref + 5);
    *temp_ref = clamp_value(new_temp, 45, 95);
    
    let rain_ref = &mut previous_weather.rain;
    let new_rain = randomness::u8_range(*rain_ref - 5, *rain_ref + 5);
    *rain_ref = clamp_value(new_rain, 0, 100);

    let wind_ref = &mut previous_weather.wind;
    let new_wind = randomness::u8_range(*wind_ref - 5, *wind_ref + 5);
    *wind_ref = clamp_value(new_wind, 2, 75);
  }

  fun explore(basecamp_address: address) acquires Basecamp{
    check_basecamp_exist_and_crew_alive(basecamp_address);
    //let lat_ref = &mut borrow_global_mut<Basecamp>(basecamp_address).lat;
    //let lat_ref = &mut borrow_global_mut<Basecamp>(basecamp_address).long;
  }

  fun get_store_items(basecamp_address: address) acquires Basecamp{
    check_basecamp_exist_and_crew_alive(basecamp_address);
    //let basecamp = borrow_global<Basecamp>(basecamp_address);
  }

  fun buy(basecamp_address: address) acquires Basecamp{
    crew_at_home(basecamp_address);
    check_basecamp_exist_and_crew_alive(basecamp_address);
    //let basecamp = borrow_global<Basecamp>(basecamp_address);
  }

  fun sell(basecamp_address: address) acquires Basecamp{
    crew_at_home(basecamp_address);
    check_basecamp_exist_and_crew_alive(basecamp_address);
    //let basecamp = borrow_global<Basecamp>(basecamp_address);
  }

  fun pack(basecamp_address: address) acquires Basecamp{
    crew_at_home(basecamp_address);
    check_basecamp_exist_and_crew_alive(basecamp_address);
    //let basecamp = borrow_global<Basecamp>(basecamp_address);
  }

  fun unpack(basecamp_address: address) acquires Basecamp{
    check_basecamp_exist_and_crew_alive(basecamp_address);
    //let basecamp = borrow_global<Basecamp>(basecamp_address);
  }

  fun clamp_value(n: u8, min: u8, max: u8): u8 {
    if (n < min) {
      min
    } else if (n > max) {
      max
    } else {
      n
    }
  }
  
}
