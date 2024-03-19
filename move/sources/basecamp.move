module basecamp::basecamp {

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

  friend basecamp::basecamp_test;

  const APP_OBJECT_SEED: vector<u8> = b"BASECAMP";
  const BASECAMP_COLLECTION_NAME: vector<u8> = b"Basecamp Collection";
  const BASECAMP_COLLECTION_DESCRIPTION: vector<u8> = b"Basecamp Collection Description";
  const BASECAMP_COLLECTION_URI: vector<u8> = b"png";

  const MAP_SIZE: u64 = 100;
  const MIN_RAIN: u8 = 0;
  const MAX_RAIN: u8 = 100;
  const MIN_WIND: u8 = 1;
  const MAX_WIND: u8 = 120;
  const MIN_TEMP: u8 = 30;
  const MAX_TEMP: u8 = 100;

  const MAX_STORE_ITEMS: u64 = 12;

  const MAX_CREW: u8 = 10;
  const MIN_HEALTH: u8 = 0;
  const MAX_HEALTH: u8 = 10;
  const MIN_STRENGTH: u8 = 1;
  const MAX_STRENGTH: u8 = 5;

  const ERR_NOT_INITIALIZED: u64 = 1;
  const ERR_NOT_ADMIN: u64 = 2;
  const ERR_MAX_CREW: u64 = 3;
  const ERR_CREW_NOT_HOME: u64 = 4;
  const ERR_BASECAMP_MISSING: u64 = 5;
  const ERR_BASECAMP_DEAD: u64 = 6;
  const ERR_MOVE_TOO_FAR: u64 = 7;
  const ERR_NOT_ENOUGH_MONEY: u64 = 8;
  const ERR_YOU_CANT_EAT_THIS: u64 = 9;
  const ERR_CREW_DEAD: u64 = 10;
  const ERR_THING_DEAD: u64 = 11;

  struct Crew has store, drop, copy {
    live: bool,
    health: u8,
    strength: u8,
    location: u64,
    backpack: vector<Thing>
  }

  struct Weather has store, drop, copy {
    temp: u8,
    rain: u8,
    wind: u8,
  }

  struct Basecamp has key {
    live: bool,
    gold: u64,
    weather: Weather,
    crew: Table<u64, Crew>,
    crew_count: u64,
    location: u64,
    store_items: vector<Thing>,
    owned_items: vector<Thing>,
    world: Table<u64, Position>,
    extend_ref: ExtendRef,
    mutator_ref: token::MutatorRef,
    burn_ref: token::BurnRef,
  }

  struct Thing has store, drop, copy {
    name: vector<u8>,
    live: bool,
    consumable: bool,
    uses: u8,
    size: u8,
    health: u8,
    strength: u8,
    cost: u64
  }

  struct Position has store, drop, copy {
    things: vector<Thing>,
  }

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

  /*
  ================================
    I N I T I A L I Z E
  ================================
  */
  fun init_module(deployer: &signer) {
    let constructor_ref = object::create_named_object(
        deployer,
        APP_OBJECT_SEED,
    );
    let extend_ref = object::generate_extend_ref(&constructor_ref);
    let app_signer = &object::generate_signer(&constructor_ref);
    move_to(deployer, MintBasecampEvents {
        mint_basecamp_events: account::new_event_handle<MintBasecampEvent>(deployer),
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

  /*
  ================================
    M I N T
  ================================
  */
  entry fun create_basecamp(user: &signer, crew_count: u8) acquires CollectionCapability, MintBasecampEvents {
    create_basecamp_internal(user, crew_count);
  }

  fun create_basecamp_internal(user: &signer, crew_count: u8): address acquires CollectionCapability, MintBasecampEvents {
    let uri = utf8(BASECAMP_COLLECTION_URI);
    let description = utf8(BASECAMP_COLLECTION_DESCRIPTION);
    let user_address = address_of(user);
    let token_name = to_string(&user_address);

    let temp = randomness::u8_range(MIN_TEMP, MAX_TEMP);
    let rain = randomness::u8_range(MIN_RAIN, MAX_RAIN);
    let wind = randomness::u8_range(MIN_WIND, MAX_WIND);
    let weather = Weather {
      temp: temp,
      rain: rain,
      wind: wind
    };

    let max_spaces = MAP_SIZE * MAP_SIZE;
    let location = randomness::u64_range(1, max_spaces);

    let world = table::new();
    let things = vector::empty<Thing>();
    let position = Position {
      things: things
    };
    table::upsert(&mut world, location, position);

    let store_items = vector::empty<Thing>();
    let owned_items = vector::empty<Thing>();
    for (i in 1..(MAX_STORE_ITEMS+1)){
      let item = construct_store_item();
      vector::push_back(&mut store_items, item);
    };

    let crew = table::new();
    let counter = 0;
    for (i in 1..(crew_count+1)){
      let crew_member = construct_crew_member(location);
      table::upsert(&mut crew, counter, crew_member);
      counter = counter + 1;
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

    let basecamp = Basecamp {
        live: true,
        gold: counter,
        weather: weather,
        crew: crew,
        crew_count: counter,
        location: location,
        store_items: store_items,
        owned_items: owned_items,
        world: world,
        extend_ref,
        mutator_ref,
        burn_ref,
    };
    move_to(token_signer_ref, basecamp);

    event::emit_event<MintBasecampEvent>(
        &mut borrow_global_mut<MintBasecampEvents>(@basecamp).mint_basecamp_events,
        MintBasecampEvent {
            basecamp_address: address_of(token_signer_ref),
            token_name,
        },
    );

    object::transfer_with_ref(object::generate_linear_transfer_ref(&transfer_ref), address_of(user));

    basecamp_address
  }

  /*
  ================================
    E N T R Y
  ================================
  */
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

  public entry fun rest_crew(basecamp_address: address) acquires Basecamp {
    check_basecamp_exist_and_crew_alive(basecamp_address);
    let basecamp = borrow_global_mut<Basecamp>(basecamp_address);
    let crew_count = basecamp.crew_count;
    for (i in 1..(crew_count+1)){
      let crew_member = table::borrow_mut(&mut basecamp.crew, i);
      let new_health = clamp_value(crew_member.health + 1, MIN_HEALTH, MAX_HEALTH);
      let new_strength = clamp_value(crew_member.strength + 1, MIN_STRENGTH, MAX_STRENGTH);
      crew_member.health = new_health;
      crew_member.strength = new_strength;
    };
    next_weather(basecamp_address);
  }

  public entry fun rest_crew_member(basecamp_address: address, crew_id: u64) acquires Basecamp {
    check_basecamp_exist_and_crew_alive(basecamp_address);
    let basecamp = borrow_global_mut<Basecamp>(basecamp_address);
    let crew_member = table::borrow_mut(&mut basecamp.crew, crew_id);
    let new_health = clamp_value(crew_member.health + 1, MIN_HEALTH, MAX_HEALTH);
    let new_strength = clamp_value(crew_member.strength + 1, MIN_STRENGTH, MAX_STRENGTH);
    crew_member.health = new_health;
    crew_member.strength = new_strength;
    next_weather(basecamp_address);
  }

  public entry fun move_crew_member(
    basecamp_address: address, 
    direction: u8, 
    distance: u64, 
    crew_id: u64
    ) acquires Basecamp {
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

  fun move_crew_member_north(
    basecamp_address: address, 
    distance: u64, 
    crew_id: u64
    ) acquires Basecamp {
    let basecamp = borrow_global_mut<Basecamp>(basecamp_address);
    let crew_member = table::borrow_mut(&mut basecamp.crew, crew_id);
    assert!(distance <= 2, ERR_MOVE_TOO_FAR);
    let multiple = distance * MAP_SIZE;
    let new_location = crew_member.location - multiple;
    assert!(new_location > 0, ERR_MOVE_TOO_FAR);
    crew_member.location = new_location;
  }

  fun move_crew_member_east(
    basecamp_address: address, 
    distance: u64, 
    crew_id: u64
    ) acquires Basecamp {
    let basecamp = borrow_global_mut<Basecamp>(basecamp_address);
    let crew_member = table::borrow_mut(&mut basecamp.crew, crew_id);
    assert!(distance <= 2, ERR_MOVE_TOO_FAR);
    let new_location = crew_member.location + distance;
    assert!(new_location < MAP_SIZE, ERR_MOVE_TOO_FAR);
    crew_member.location = new_location;
  }

  fun move_crew_member_south(
    basecamp_address: address, 
    distance: u64, 
    crew_id: u64
    ) acquires Basecamp {
    let basecamp = borrow_global_mut<Basecamp>(basecamp_address);
    let crew_member = table::borrow_mut(&mut basecamp.crew, crew_id);
    assert!(distance <= 2, ERR_MOVE_TOO_FAR);
    let multiple = distance * MAP_SIZE;
    let new_location = crew_member.location + multiple;
    assert!(new_location < MAP_SIZE, ERR_MOVE_TOO_FAR);
    crew_member.location = new_location;
  }

  fun move_crew_member_west(
    basecamp_address: address, 
    distance: u64, 
    crew_id: u64
    ) acquires Basecamp {
    let basecamp = borrow_global_mut<Basecamp>(basecamp_address);
    let crew_member = table::borrow_mut(&mut basecamp.crew, crew_id);
    assert!(distance <= 2, ERR_MOVE_TOO_FAR);
    let new_location = crew_member.location - distance;
    assert!(new_location > 0, ERR_MOVE_TOO_FAR);
    crew_member.location = new_location;
  }

  public entry fun move_basecamp(
    basecamp_address: address, 
    direction: u8
    ) acquires Basecamp {
    check_basecamp_exist_and_crew_alive(basecamp_address);
    crew_at_home(basecamp_address);
    pay_for_move(basecamp_address);
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

  fun pay_for_move(basecamp_address: address) acquires Basecamp {
    let gold_ref = &mut borrow_global_mut<Basecamp>(basecamp_address).gold;
    let new_gold = *gold_ref - 1;
    assert!(new_gold > 0, ERR_NOT_ENOUGH_MONEY);
    *gold_ref = new_gold;
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

  fun next_weather(basecamp_address: address): Weather acquires Basecamp {
    check_basecamp_exist_and_crew_alive(basecamp_address);
    let weather = &mut borrow_global_mut<Basecamp>(basecamp_address).weather;

    let temp_ref = &mut weather.temp;
    let low_temp = MIN_TEMP;
    if (*temp_ref > 5){
      low_temp = *temp_ref - 5;
    };
    let new_temp = randomness::u8_range(low_temp, *temp_ref + 5);
    *temp_ref = clamp_value(new_temp, MIN_TEMP, MAX_TEMP);

    let rain_ref = &mut weather.rain;
    let low_rain = MIN_RAIN;
    if (*rain_ref > 5){
      low_rain = *rain_ref - 5;
    };
    let new_rain = randomness::u8_range(low_rain, *rain_ref + 5);
    *rain_ref = clamp_value(new_rain, MIN_RAIN, MAX_RAIN);

    let wind_ref = &mut weather.wind;
    let low_wind = MIN_WIND;
    if (*wind_ref > 5){
      low_wind = *wind_ref - 5;
    };
    let new_wind = randomness::u8_range(low_wind, *wind_ref + 5);
    *wind_ref = clamp_value(new_wind, MIN_WIND, MAX_WIND);

    borrow_global<Basecamp>(basecamp_address).weather
  }

  public entry fun explore(
    basecamp_address: address, 
    location_id: u64
    ) acquires Basecamp{
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
  }

  public entry fun supply_drop(
    basecamp_address: address
    ) acquires Basecamp{
    crew_at_home(basecamp_address);
    check_basecamp_exist_and_crew_alive(basecamp_address);
    let basecamp = borrow_global_mut<Basecamp>(basecamp_address);
    let store_items = basecamp.store_items;
    let store_items_length = vector::length(&store_items);
    let fill = MAX_STORE_ITEMS - store_items_length;
    for (i in 1..(fill+1)){
      let item = construct_store_item();
      vector::push_back(&mut store_items, item);
    };
  }

  public entry fun buy(
    basecamp_address: address, 
    thing_id: u64, 
    name: vector<u8>
    ) acquires Basecamp {
    crew_at_home(basecamp_address);
    check_basecamp_exist_and_crew_alive(basecamp_address);
    let basecamp = borrow_global_mut<Basecamp>(basecamp_address);
    let item = vector::borrow(&basecamp.store_items, thing_id);
    assert!(basecamp.gold > item.cost, ERR_NOT_ENOUGH_MONEY);
    basecamp.gold = basecamp.gold - item.cost;
    let thing = Thing {
      name: name,
      live: item.live,
      consumable: item.consumable,
      uses: item.uses,
      size: item.size,
      health: item.health,
      strength: item.strength,
      cost: item.cost
    };
    vector::push_back<Thing>(&mut basecamp.owned_items, thing);
    vector::remove(&mut basecamp.store_items, thing_id);
  }

  public entry fun sell(
    basecamp_address: address, 
    thing_id: u64
    ) acquires Basecamp{
    crew_at_home(basecamp_address);
    check_basecamp_exist_and_crew_alive(basecamp_address);
    let basecamp = borrow_global_mut<Basecamp>(basecamp_address);
    let item = vector::borrow(&basecamp.owned_items, thing_id);
    basecamp.gold = basecamp.gold + item.cost;
    vector::remove(&mut basecamp.owned_items, thing_id);
  }

  public entry fun pack(
    basecamp_address: address, 
    crew_id: u64, 
    thing_id: u64, 
    location_id: u64, 
    store_items: bool
    ) acquires Basecamp{
    check_basecamp_exist_and_crew_alive(basecamp_address);
    let basecamp = borrow_global_mut<Basecamp>(basecamp_address);
    if (store_items == true){
      let thing = vector::borrow(&basecamp.owned_items, thing_id);
      let crew_member = table::borrow_mut(&mut basecamp.crew, crew_id);
      let backpack = crew_member.backpack;
      let item = Thing {
        name: thing.name,
        live: thing.live,
        consumable: thing.consumable,
        uses: thing.uses,
        size: thing.size,
        health: thing.health,
        strength: thing.strength,
        cost: thing.cost
      };
      vector::push_back<Thing>(&mut backpack, item);
      vector::remove(&mut basecamp.owned_items, thing_id);
    } else {
      let world = table::borrow_mut(&mut basecamp.world, location_id);
      let thing = vector::borrow(&world.things, thing_id);
      let crew_member = table::borrow_mut(&mut basecamp.crew, crew_id);
      let backpack = crew_member.backpack;
      let item = Thing {
        name: thing.name,
        live: thing.live,
        consumable: thing.consumable,
        uses: thing.uses,
        size: thing.size,
        health: thing.health,
        strength: thing.strength,
        cost: thing.cost
      };
      vector::push_back<Thing>(&mut backpack, item);
      vector::remove(&mut world.things, thing_id);
    }
  }

  public entry fun unpack(
    basecamp_address: address, 
    crew_id: u64, 
    thing_id: u64
    ) acquires Basecamp{
    check_basecamp_exist_and_crew_alive(basecamp_address);
    let basecamp = borrow_global_mut<Basecamp>(basecamp_address);
    let crew_member = table::borrow_mut(&mut basecamp.crew, crew_id);
    let thing = vector::borrow(&crew_member.backpack, thing_id);
    if (crew_member.location == basecamp.location){
      let item = Thing {
        name: thing.name,
        live: thing.live,
        consumable: thing.consumable,
        uses: thing.uses,
        size: thing.size,
        health: thing.health,
        strength: thing.strength,
        cost: thing.cost
      };
      vector::push_back<Thing>(&mut basecamp.owned_items, item); 
    } else {
      let world = table::borrow_mut(&mut basecamp.world, basecamp.location);
      let item = Thing {
        name: thing.name,
        live: thing.live,
        consumable: thing.consumable,
        uses: thing.uses,
        size: thing.size,
        health: thing.health,
        strength: thing.strength,
        cost: thing.cost
      };
      vector::push_back<Thing>(&mut world.things, item); 
    };
    vector::remove(&mut crew_member.backpack, thing_id);
  }

  public entry fun fight(
    basecamp_address: address, 
    crew_id: u64, 
    thing_id: u64, 
    location_id: u64
    ) acquires Basecamp{
    check_basecamp_exist_and_crew_alive(basecamp_address);
    let basecamp = borrow_global_mut<Basecamp>(basecamp_address);
    let world = table::borrow_mut(&mut basecamp.world, location_id);
    let crew_member = table::borrow_mut(&mut basecamp.crew, crew_id);
    let thing = vector::borrow_mut(&mut world.things, thing_id);
    assert!(crew_member.live == true, ERR_CREW_DEAD);
    assert!(thing.live == true, ERR_THING_DEAD);
    thing.health = thing.health - 1;
    thing.strength = thing.strength - 1;
    if (thing.health == 0){
      thing.live = false;
      thing.consumable = true;
    } else {
      if (thing.strength > 0){
        let min_damage = clamp_value(thing.strength - 2, 0, thing.strength);
        let damage_to_crew = randomness::u8_range(min_damage, thing.strength);
        crew_member.health = crew_member.health - damage_to_crew;
        if (crew_member.health == 0){
          crew_member.live = false;
        }
      }
    };
  }

  public entry fun consume(
    basecamp_address: address, 
    crew_id: u64, 
    thing_id: u64
    ) acquires Basecamp{
    check_basecamp_exist_and_crew_alive(basecamp_address);
    let basecamp = borrow_global_mut<Basecamp>(basecamp_address);
    let crew_member = table::borrow_mut(&mut basecamp.crew, crew_id);
    let thing = vector::borrow_mut(&mut crew_member.backpack, thing_id);
    assert!(thing.consumable == true, ERR_YOU_CANT_EAT_THIS);
    assert!(thing.uses > 0, ERR_YOU_CANT_EAT_THIS);
    if (thing.strength == 0){
      crew_member.health = crew_member.health + thing.health;
      crew_member.strength = crew_member.strength + 1;
    } else {
      let poison = randomness::u8_range(0, 100);
      if (poison < 100){
        crew_member.health = crew_member.health + thing.health;
        crew_member.strength = crew_member.strength + 1;
      } else {
        crew_member.health = crew_member.health - 1; 
        crew_member.strength = crew_member.strength - 1;
        if (crew_member.health == 0){
          crew_member.live = false;
        }
      }
    };
    thing.uses = thing.uses - 1;
    if (thing.uses == 0){
      vector::remove(&mut crew_member.backpack, thing_id);
    };
  }

  /*
  ================================
    A S S E T S
  ================================
  */
  fun construct_crew_member(location: u64): Crew {
    let strength = randomness::u8_range(MIN_STRENGTH, MAX_STRENGTH);
    let crew_member = Crew {
      live: true,
      health: MAX_HEALTH,
      strength: strength,
      location: location,
      backpack: vector::empty<Thing>()
    };
    crew_member
  }

  fun construct_store_item(): Thing {
    let rarity = randomness::u8_range(1, 100);
    let consumable_random = randomness::u8_range(1, 4);
    let item = Thing {
      name: b"...",
      live: false,
      consumable: false,
      uses: 0,
      size: 0,
      health: 0,
      strength: 0,
      cost: 0
    };
    if (consumable_random == 1){
      item.consumable = true;
    };
    if (item.consumable == true){
      if (rarity > 90){
        item.uses = randomness::u8_range(1, 10);
        item.cost = randomness::u64_range(1, 10);
        item.size = randomness::u8_range(1, 10);
        item.health = randomness::u8_range(0, 10);
        item.strength = randomness::u8_range(0, 10);
      } else {
        item.uses = randomness::u8_range(1, 10);
        item.cost = randomness::u64_range(1, 10);
        item.size = randomness::u8_range(1, 10);
        item.health = randomness::u8_range(0, 10);
        item.strength = randomness::u8_range(0, 10);
      };
    } else {
      if (rarity == 100) {
        item.uses = randomness::u8_range(1, 10);
        item.cost = randomness::u64_range(1, 10);
        item.size = randomness::u8_range(1, 10);
        item.health = randomness::u8_range(0, 10);
        item.strength = randomness::u8_range(0, 10);
      } else if (rarity > 90){
        item.uses = randomness::u8_range(1, 10);
        item.cost = randomness::u64_range(1, 10);
        item.size = randomness::u8_range(1, 10);
        item.health = randomness::u8_range(0, 10);
        item.strength = randomness::u8_range(0, 10);
      } else if (rarity > 80){
        item.uses = randomness::u8_range(1, 10);
        item.cost = randomness::u64_range(1, 10);
        item.size = randomness::u8_range(1, 10);
        item.health = randomness::u8_range(0, 10);
        item.strength = randomness::u8_range(0, 10);
      } else  if (rarity > 70){
        item.uses = randomness::u8_range(1, 10);
        item.cost = randomness::u64_range(1, 10);
        item.size = randomness::u8_range(1, 10);
        item.health = randomness::u8_range(0, 10);
        item.strength = randomness::u8_range(0, 10);
      } else {
        item.uses = randomness::u8_range(1, 10);
        item.cost = randomness::u64_range(1, 10);
        item.size = randomness::u8_range(1, 10);
        item.health = randomness::u8_range(0, 10);
        item.strength = randomness::u8_range(0, 10);
      };
    };
    
    item
  }

  fun construct_thing(): Thing {
    let rarity = randomness::u8_range(1, 100);
    let live_odds = randomness::u8_range(1, 10);

    let item = Thing {
      name: b"...",
      live: false,
      consumable: false,
      uses: 0,
      size: 0,
      health: 0,
      strength: 0,
      cost: 0
    };

    if (live_odds < 9){
      item.live = true;
      if (rarity == 100) {
        item.uses = randomness::u8_range(1, 10);
        item.cost = randomness::u64_range(1, 10);
        item.size = randomness::u8_range(10, 20);
        item.health = randomness::u8_range(10, item.size);
        item.strength = randomness::u8_range(10, item.size);
      } else if (rarity > 90){
        item.uses = randomness::u8_range(1, 10);
        item.cost = randomness::u64_range(1, 10);
        item.size = randomness::u8_range(7, 10);
        item.health = randomness::u8_range(5, item.size);
        item.strength = randomness::u8_range(1, item.size);
      } else if (rarity > 70){
        item.uses = randomness::u8_range(1, 10);
        item.cost = randomness::u64_range(1, 10);
        item.size = randomness::u8_range(3, 7);
        item.health = randomness::u8_range(3, item.size);
        item.strength = randomness::u8_range(1, item.size);
      } else  if (rarity > 40){
        item.uses = randomness::u8_range(1, 10);
        item.cost = randomness::u64_range(1, 10);
        item.size = randomness::u8_range(2, 5);
        item.health = randomness::u8_range(1, item.size);
        item.strength = randomness::u8_range(1, item.size);
      } else {
        item.uses = randomness::u8_range(1, 10);
        item.cost = randomness::u64_range(1, 10);
        item.size = randomness::u8_range(1, 2);
        item.health = randomness::u8_range(1, item.size);
        item.strength = randomness::u8_range(1, item.size);
      }
    } else {
      let consumable_random = randomness::u8_range(1, 2);
      if (consumable_random == 2){
        item.consumable = true;
      };
      if (item.consumable == true){
        if (rarity == 100){
          item.uses = randomness::u8_range(1, 10);
          item.cost = randomness::u64_range(1, 10);
          item.size = randomness::u8_range(1, 10);
          item.health = randomness::u8_range(0, item.size);
          item.strength = randomness::u8_range(0, item.size);
        } else if (rarity > 90){
          item.uses = randomness::u8_range(1, 10);
          item.cost = randomness::u64_range(1, 10);
          item.size = randomness::u8_range(4, 10);
          item.health = randomness::u8_range(1, item.size);
          item.strength = randomness::u8_range(0, item.size);
        } else {
          item.uses = randomness::u8_range(1, 10);
          item.cost = randomness::u64_range(1, 10);
          item.size = randomness::u8_range(1, 3);
          item.health = randomness::u8_range(1, item.size);
          item.strength = randomness::u8_range(0, item.size);
        }
      } else {
        if (rarity == 100){
          item.uses = randomness::u8_range(1, 10);
          item.cost = randomness::u64_range(1, 10);
          item.size = randomness::u8_range(1, 10);
          item.health = randomness::u8_range(0, item.size);
          item.strength = randomness::u8_range(0, item.size);
        } else if (rarity > 90){
          item.uses = randomness::u8_range(1, 10);
          item.cost = randomness::u64_range(1, 10);
          item.size = randomness::u8_range(4, 10);
          item.health = randomness::u8_range(1, item.size);
          item.strength = randomness::u8_range(0, item.size);
        } else {
          item.uses = randomness::u8_range(1, 10);
          item.cost = randomness::u64_range(1, 10);
          item.size = randomness::u8_range(1, 3);
          item.health = randomness::u8_range(1, item.size);
          item.strength = randomness::u8_range(0, item.size);
        }
      }
    };
    item
  }

  /*
  ================================
    U T I L I T Y
  ================================
  */
  fun clamp_value(n: u8, min: u8, max: u8): u8 {
    if (n < min) {
      min
    } else if (n > max) {
      max
    } else {
      n
    }
  }
  /*
  ================================
    V I E W   F U N C T I O N S
  ================================
  */
  #[view]
  public fun get_basecamp_live_status(
    basecamp_address: address
  ): bool acquires Basecamp {
    check_basecamp_exist_and_crew_alive(basecamp_address);
    let basecamp = borrow_global<Basecamp>(basecamp_address);
    basecamp.live
  }

  #[view]
  public fun get_basecamp_gold_count(
    basecamp_address: address
  ): u64 acquires Basecamp {
    check_basecamp_exist_and_crew_alive(basecamp_address);
    let basecamp = borrow_global<Basecamp>(basecamp_address);
    basecamp.gold
  }

  #[view]
  public fun get_basecamp_crew_member(
    basecamp_address: address,
    crew_id: u64
    ): (
      bool,
      u8,
      u8,
      u64,
      vector<Thing>
      ) acquires Basecamp {
    check_basecamp_exist_and_crew_alive(basecamp_address);
    let basecamp = borrow_global<Basecamp>(basecamp_address);
    let crew_member = table::borrow(&basecamp.crew, crew_id);
    (crew_member.live, 
    crew_member.health, 
    crew_member.strength, 
    crew_member.location,
    crew_member.backpack)
  }

  #[view]
  public fun get_basecamp_weather(
    basecamp_address: address
  ): Weather acquires Basecamp {
    check_basecamp_exist_and_crew_alive(basecamp_address);
    let basecamp = borrow_global<Basecamp>(basecamp_address);
    basecamp.weather
  }

  #[view]
  public fun get_basecamp_location(
    basecamp_address: address
  ): u64 acquires Basecamp {
    check_basecamp_exist_and_crew_alive(basecamp_address);
    let basecamp = borrow_global_mut<Basecamp>(basecamp_address);
    basecamp.location
  }

  #[view]
  public fun get_basecamp_store_items(
    basecamp_address: address
    ): vector<Thing> acquires Basecamp {
    check_basecamp_exist_and_crew_alive(basecamp_address);
    let basecamp = borrow_global<Basecamp>(basecamp_address);
    basecamp.store_items
  }

  #[view]
  public fun get_basecamp_owned_items(
    basecamp_address: address
    ): vector<Thing> acquires Basecamp {
    check_basecamp_exist_and_crew_alive(basecamp_address);
    let basecamp = borrow_global<Basecamp>(basecamp_address);
    basecamp.owned_items
  }

  #[view]
  public fun get_world_map_location(
    basecamp_address: address,
    location_id: u64
    ): vector<Thing> acquires Basecamp {
    check_basecamp_exist_and_crew_alive(basecamp_address);
    let basecamp = borrow_global<Basecamp>(basecamp_address);
    let location = table::borrow(&basecamp.world, location_id);
    location.things
  }
  
  /*
  ================================
    T E S T   F U N C T I O N S
  ================================
  */
  #[test_only]
  public(friend) fun init_module_test(developer: &signer) {
      account::create_account_for_test(address_of(developer));
      init_module(developer)
  }

  #[test_only]
  public(friend) fun create_basecamp_internal_test(developer: &signer, crew_count: u8): address acquires CollectionCapability, MintBasecampEvents {
      create_basecamp_internal(developer, crew_count)
  }

  #[test_only]
  public(friend) fun move_crew_member_test(
    basecamp_address: address, 
    direction: u8, 
    distance: u64, 
    crew_id: u64
    ) acquires Basecamp {
      move_crew_member(basecamp_address, direction, distance, crew_id)
  }


}
