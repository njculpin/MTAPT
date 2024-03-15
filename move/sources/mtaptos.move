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
  const MIN_HEALTH: u8 = 0;
  const MAX_HEALTH: u8 = 10;
  const MIN_STRENGTH: u8 = 1;
  const MAX_STRENGTH: u8 = 5;
  const MIN_RAIN: u8 = 0;
  const MAX_RAIN: u8 = 100;
  const MIN_WIND: u8 = 1;
  const MAX_WIND: u8 = 120;
  const MIN_TEMP: u8 = 30;
  const MAX_TEMP: u8 = 100;

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
    location: u64,
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
    location: u64,
    world: Table<u64, Position>,
    extend_ref: ExtendRef,
    mutator_ref: token::MutatorRef,
    burn_ref: token::BurnRef,
  }

  struct Thing has store, drop, copy {
    consumable: bool,
    size: u8,
    live: bool,
    health: u8,
    strength: u8
  }

  struct Position has store, drop, copy {
    things: vector<Thing>,
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
    let temp = randomness::u8_range(MIN_TEMP, MAX_TEMP);
    let rain = randomness::u8_range(MIN_RAIN, MAX_RAIN);
    let wind = randomness::u8_range(MIN_WIND, MAX_WIND);
    let weather = Weather {
      temp: temp,
      rain: rain,
      wind: wind
    };

    // start location
    let max_spaces = MAP_SIZE * MAP_SIZE;
    let location = randomness::u64_range(1, max_spaces);

    // world 
    let world = table::new();
    let things = vector::empty<Thing>();
    let position = Position {
      things: things
    };
    table::upsert(&mut world, location, position);

    // crew,
    let crew = table::new();
    let counter = 1;
    for (i in 1..(crew_count+1)){
      let strength = randomness::u8_range(MIN_STRENGTH, MAX_STRENGTH);
      let crew_member = Crew {
        live: true,
        health: MAX_HEALTH,
        strength: strength,
        location: location,
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
        location: location,
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
    let basecamp = borrow_global_mut<Basecamp>(basecamp_address);
    let crew_count = basecamp.crew_count;
    let crew_home_counter = 0;
    for (i in 1..(crew_count+1)){
      let crew_member = table::borrow_mut(&mut basecamp.crew, i);
      if (crew_member.location == basecamp.location){
        crew_home_counter = crew_home_counter + 1;
      }
    };
    assert!(crew_home_counter > 0, ERR_CREW_NOT_HOME);
  }

  fun rest_crew(basecamp_address: address) acquires Basecamp {
    check_basecamp_exist_and_crew_alive(basecamp_address);
    let basecamp = borrow_global_mut<Basecamp>(basecamp_address);
    let crew_count = basecamp.crew_count;
    for (i in 1..(crew_count+1)){
      let crew_member = table::borrow_mut(&mut basecamp.crew, i);
      let crew_id = i;
      let new_health = clamp_value(crew_member.health + 1, MIN_HEALTH, MAX_HEALTH);
      let new_strength = clamp_value(crew_member.strength + 1, MIN_STRENGTH, MAX_STRENGTH);
      crew_member.health = new_health;
      crew_member.strength = new_strength;
    };
    next_weather(basecamp_address);
  }

  fun rest_crew_member(basecamp_address: address, crew_id: u64) acquires Basecamp {
    check_basecamp_exist_and_crew_alive(basecamp_address);
    let basecamp = borrow_global_mut<Basecamp>(basecamp_address);
    let crew_member = table::borrow_mut(&mut basecamp.crew, crew_id);
    let new_health = clamp_value(crew_member.health + 1, MIN_HEALTH, MAX_HEALTH);
    let new_strength = clamp_value(crew_member.strength + 1, MIN_STRENGTH, MAX_STRENGTH);
    crew_member.health = new_health;
    crew_member.strength = new_strength;
    next_weather(basecamp_address);
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
    next_weather(basecamp_address);
  }

  fun move_crew_member_north(basecamp_address: address, distance: u64, crew_id: u64) acquires Basecamp {
    let basecamp = borrow_global_mut<Basecamp>(basecamp_address);
    let crew_member = table::borrow_mut(&mut basecamp.crew, crew_id);
    assert!(distance <= 2, ERR_MOVE_TOO_FAR);
    let multiple = distance * MAP_SIZE;
    let new_location = crew_member.location - multiple;
    assert!(new_location > 0, ERR_MOVE_TOO_FAR);
    crew_member.location = new_location;
  }

  fun move_crew_member_east(basecamp_address: address, distance: u64, crew_id: u64) acquires Basecamp {
    let basecamp = borrow_global_mut<Basecamp>(basecamp_address);
    let crew_member = table::borrow_mut(&mut basecamp.crew, crew_id);
    assert!(distance <= 2, ERR_MOVE_TOO_FAR);
    let new_location = crew_member.location + distance;
    assert!(new_location < MAP_SIZE, ERR_MOVE_TOO_FAR);
    crew_member.location = new_location;
  }

  fun move_crew_member_south(basecamp_address: address, distance: u64, crew_id: u64) acquires Basecamp {
    let basecamp = borrow_global_mut<Basecamp>(basecamp_address);
    let crew_member = table::borrow_mut(&mut basecamp.crew, crew_id);
    assert!(distance <= 2, ERR_MOVE_TOO_FAR);
    let multiple = distance * MAP_SIZE;
    let new_location = crew_member.location + multiple;
    assert!(new_location < MAP_SIZE, ERR_MOVE_TOO_FAR);
    crew_member.location = new_location;
  }

  fun move_crew_member_west(basecamp_address: address, distance: u64, crew_id: u64) acquires Basecamp {
    let basecamp = borrow_global_mut<Basecamp>(basecamp_address);
    let crew_member = table::borrow_mut(&mut basecamp.crew, crew_id);
    assert!(distance <= 2, ERR_MOVE_TOO_FAR);
    let new_location = crew_member.location - distance;
    assert!(new_location > 0, ERR_MOVE_TOO_FAR);
    crew_member.location = new_location;
  }

  fun move_basecamp(basecamp_address: address, direction: u8) acquires Basecamp {
    check_basecamp_exist_and_crew_alive(basecamp_address);
    crew_at_home(basecamp_address);
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
    next_weather(basecamp_address);
  }

  fun move_basecamp_north(basecamp_address: address) acquires Basecamp {
    let location_ref = &mut borrow_global_mut<Basecamp>(basecamp_address).location;
    let new_location = *location_ref - MAP_SIZE;
     assert!(new_location > 0, ERR_MOVE_TOO_FAR);
    *location_ref = new_location;
  }

  fun move_basecamp_south(basecamp_address: address) acquires Basecamp {
    let location_ref = &mut borrow_global_mut<Basecamp>(basecamp_address).location;
    let new_location = *location_ref + MAP_SIZE;
    assert!(new_location < MAP_SIZE, ERR_MOVE_TOO_FAR);
    *location_ref = new_location;
  }

  fun move_basecamp_east(basecamp_address: address) acquires Basecamp {
    let location_ref = &mut borrow_global_mut<Basecamp>(basecamp_address).location;
    let new_location = *location_ref + 1;
    assert!(new_location < MAP_SIZE, ERR_MOVE_TOO_FAR);
    *location_ref = new_location;
  }

  fun move_basecamp_west(basecamp_address: address) acquires Basecamp {
    let location_ref = &mut borrow_global_mut<Basecamp>(basecamp_address).location;
    let new_location = *location_ref - 1;
    assert!(new_location > 0, ERR_MOVE_TOO_FAR);
    *location_ref = new_location;
  }

  fun next_weather(basecamp_address: address) acquires Basecamp {
    check_basecamp_exist_and_crew_alive(basecamp_address);
    let previous_weather = &mut borrow_global_mut<Basecamp>(basecamp_address).weather;
    let temp_ref = &mut previous_weather.temp;
    let new_temp = randomness::u8_range(*temp_ref - 5, *temp_ref + 5);
    *temp_ref = clamp_value(new_temp, MIN_TEMP, MAX_TEMP);
    let rain_ref = &mut previous_weather.rain;
    let new_rain = randomness::u8_range(*rain_ref - 5, *rain_ref + 5);
    *rain_ref = clamp_value(new_rain, MIN_RAIN, MAX_RAIN);
    let wind_ref = &mut previous_weather.wind;
    let new_wind = randomness::u8_range(*wind_ref - 5, *wind_ref + 5);
    *wind_ref = clamp_value(new_wind, MIN_WIND, MAX_WIND);
  }

  fun explore(basecamp_address: address, location_id: u64) acquires Basecamp{
    check_basecamp_exist_and_crew_alive(basecamp_address);
    let basecamp = borrow_global_mut<Basecamp>(basecamp_address);
    let crew_count = basecamp.crew_count;
    let world = table::borrow_mut(&mut basecamp.world, location_id);
    let things = world.things;
    for (i in 1..(crew_count+1)){
      let crew_id = i;
      let crew_member = table::borrow_mut(&mut basecamp.crew, crew_id);
      let new_strength = clamp_value(crew_member.strength - 1, 0, 5);
      crew_member.strength = new_strength;
      if (crew_member.location == location_id){
          let discovery = construct_thing();
          vector::push_back(&mut things, discovery);
      }
    };
    next_weather(basecamp_address);
    things;
  }

  fun construct_thing(): Thing {
    let rarity = randomness::u8_range(1, 100);
    let live_odds = randomness::u8_range(1, 10);
    let live = false;
    let consumable = false;
    let size = 1;
    let health = 0;
    let strength = 0;
    if (live_odds < 9){
      live = true;
      if (rarity == 100) {
        // wtf.
        size = randomness::u8_range(10, 20);
        health = randomness::u8_range(10, size);
        strength = randomness::u8_range(10, size);
      } else if (rarity > 90){
        // bears, moose, etc...
        size = randomness::u8_range(7, 10);
        health = randomness::u8_range(5, size);
        strength = randomness::u8_range(1, size);
      } else if (rarity > 70){
        // deer, people, etc...
        size = randomness::u8_range(3, 7);
        health = randomness::u8_range(3, size);
        strength = randomness::u8_range(1, size);
      } else  if (rarity > 40){
        // coyote, racoons, etc...
        size = randomness::u8_range(2, 5);
        health = randomness::u8_range(1, size);
        strength = randomness::u8_range(1, size);
      } else {
        // rabbits, snakes, etc...
        size = randomness::u8_range(1, 2);
        health = randomness::u8_range(1, size);
        strength = randomness::u8_range(1, size);
      }
    } else {
      let consumable_random = randomness::u8_range(1, 2);
      if (consumable_random == 2){
        consumable = true;
      };
      if (rarity == 100){
        // wtf.
        size = randomness::u8_range(1, 10);
        health = randomness::u8_range(0, size);
        strength = randomness::u8_range(0, size);
      } else if (rarity > 90){
        // gold deposit, rare plants, etc..
        size = randomness::u8_range(4, 10);
        health = randomness::u8_range(1, size);
        strength = randomness::u8_range(0, size);
      } else {
        // berries, mushrooms, poison ivy, etc...
        size = randomness::u8_range(1, 3);
        health = randomness::u8_range(1, size);
        strength = randomness::u8_range(0, size);
      }
    };
    let discovery = Thing {
      consumable: consumable,
      live: live,
      size: size,
      health: health,
      strength: strength
    };
    discovery
  }

  fun get_store_items(basecamp_address: address) acquires Basecamp{
    check_basecamp_exist_and_crew_alive(basecamp_address);
    //let basecamp = borrow_global<Basecamp>(basecamp_address);
  }

  fun buy(basecamp_address: address, thing_id: u64) acquires Basecamp{
    crew_at_home(basecamp_address);
    check_basecamp_exist_and_crew_alive(basecamp_address);
    //let basecamp = borrow_global<Basecamp>(basecamp_address);
  }

  fun sell(basecamp_address: address, thing_id: u64) acquires Basecamp{
    crew_at_home(basecamp_address);
    check_basecamp_exist_and_crew_alive(basecamp_address);
    //let basecamp = borrow_global<Basecamp>(basecamp_address);
  }

  fun pack(basecamp_address: address, crew_id: u64, thing_id: u64, location_id: u64) acquires Basecamp{
    check_basecamp_exist_and_crew_alive(basecamp_address);
    //let basecamp = borrow_global<Basecamp>(basecamp_address);
  }

  fun unpack(basecamp_address: address, crew_id: u64, thing_id: u64, location_id: u64) acquires Basecamp{
    check_basecamp_exist_and_crew_alive(basecamp_address);
    //let basecamp = borrow_global<Basecamp>(basecamp_address);
  }

  fun attack_and_kill(basecamp_address: address, crew_id: u64, thing_id: u64, location_id: u64) acquires Basecamp{
    check_basecamp_exist_and_crew_alive(basecamp_address);
    //let basecamp = borrow_global<Basecamp>(basecamp_address);
  }

  fun consume(basecamp_address: address, crew_id: u64, thing_id: u64, location_id: u64) acquires Basecamp{
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
