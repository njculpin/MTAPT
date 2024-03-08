module basecamp::main {

  use aptos_framework::account;
  use aptos_framework::event;
  use aptos_framework::object;
  use aptos_framework::randomness;
  use aptos_framework::object::ExtendRef;
  use aptos_std::string_utils::{to_string};
  use std::option;
  use std::signer::address_of;
  use std::string::{String, utf8};
  use std::simple_map::{Self, SimpleMap};
  use aptos_token_objects::collection;
  use aptos_token_objects::token;
  use std::timestamp;

  const APP_OBJECT_SEED: vector<u8> = b"BASECAMP";
  const BASECAMP_COLLECTION_NAME: vector<u8> = b"Basecamp Collection";
  const BASECAMP_COLLECTION_DESCRIPTION: vector<u8> = b"Basecamp Collection Description";
  const BASECAMP_COLLECTION_URI: vector<u8> = b"png";
  const ERR_NOT_INITIALIZED: u64 = 1;
  const ERR_NOT_ADMIN: u64 = 1;

  struct Weather has store, drop, copy {
    time: u64,
    temp: u8,
    rain: u8,
    wind: u8,
  }

  struct Crew has store, drop, copy {
    live: bool,
    health: u8,
    strength: u8,
    endurance: u8,
    intelligence: u8,
    perception: u8,
    speed: u8,
  }

  struct Discovery has store, drop, copy {
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
    x: u8,
    y: u8,
    discovery_count: u8,
    discoveries: SimpleMap<u64, Discovery>
  }

  struct Basecamp has key {
    gold: u8,
    weather: Weather,
    crew: SimpleMap<u8, Crew>,
    world: SimpleMap<u64, Position>,
    position: Position,
    home: Position,
    extend_ref: ExtendRef,
    mutator_ref: token::MutatorRef,
    burn_ref: token::BurnRef,
  }

  struct WorldMap has key {
    world: SimpleMap<u64, Position>
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

    // World Map to store large discoveries
    let world:SimpleMap<u64,Position> = simple_map::create(); 
    let world_map = WorldMap {
      world: world
    };
    move_to(app_signer, world_map);
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

    let uri = utf8(BASECAMP_COLLECTION_URI);
    let description = utf8(BASECAMP_COLLECTION_DESCRIPTION);
    let user_address = address_of(user);
    let token_name = to_string(&user_address);
    
    // gold
    let minimum_gold = crew_count * 2;
    let maximum_gold = crew_count * 10;
    let gold = randomness::u8_range(minimum_gold, maximum_gold);

    // weather,
    let time = timestamp::now_microseconds();
    let temp = randomness::u8_range(45, 75);
    let rain = randomness::u8_range(0, 50);
    let wind = randomness::u8_range(5, 12);
    let weather = Weather {
      time: time,
      temp: temp,
      rain: rain,
      wind: wind
    };

    // crew,
    let crew:SimpleMap<u8,Crew> = simple_map::create();
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
      };
      simple_map::add(&mut crew,i,crew_member); 
    };

    // visited map,
    let world:SimpleMap<u64,Position> = simple_map::create(); 
    let discoveries:SimpleMap<u64,Discovery> = simple_map::create(); 
    
    // starting position,
    let position = Position {
      x: 1,
      y: 1,
      discovery_count: 0
      discoveries: discoveries
    };
    simple_map::add(&mut world,1,position); 

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
        gold: gold,
        weather: weather,
        crew: crew,
        world: world,
        position: position,
        home: position,
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
    assert!(basecamp_exists, BASECAMP_MISSING);
    let basecamp = borrow_global<Basecamp>(basecamp_address);
    // check if all crew are still alive
   //  assert!(aptogotchi_ref.live, EDEAD_APTOGOTCHI_CANNOT_MOVE)
  }

  fun crew_at_home(basecamp_address: address) acquires Basecamp {
    check_basecamp_exist_and_crew_alive(basecamp_address);
    let basecamp = borrow_global<Basecamp>(basecamp_address);
    assert!(basecamp.position.x == basecamp.home.x, NOT_HOME);
    assert!(basecamp.position.y == basecamp.home.y, NOT_HOME);
  }

  fun rest(basecamp_address: address){
    check_basecamp_exist_and_crew_alive(basecamp_address);
    let basecamp = borrow_global<Basecamp>(basecamp_address);
  }

  fun move(basecamp_address: address){
    check_basecamp_exist_and_crew_alive(basecamp_address);
    let basecamp = borrow_global<Basecamp>(basecamp_address);
  }

  fun next_weather(basecamp_address: address){
    check_basecamp_exist_and_crew_alive(basecamp_address);
    let basecamp = borrow_global<Basecamp>(basecamp_address);
  }

  fun explore(basecamp_address: address){
    check_basecamp_exist_and_crew_alive(basecamp_address);
    let basecamp = borrow_global<Basecamp>(basecamp_address);
  }

  fun get_store_items(basecamp_address: address){
    check_basecamp_exist_and_crew_alive(basecamp_address);
    let basecamp = borrow_global<Basecamp>(basecamp_address);
  }

  fun buy(basecamp_address: address){
    crew_at_home(basecamp_address);
    check_basecamp_exist_and_crew_alive(basecamp_address);
    let basecamp = borrow_global<Basecamp>(basecamp_address);
  }

  fun sell(basecamp_address: address){
    crew_at_home(basecamp_address);
    check_basecamp_exist_and_crew_alive(basecamp_address);
    let basecamp = borrow_global<Basecamp>(basecamp_address);
  }

  fun pack(basecamp_address: address){
    crew_at_home(basecamp_address);
    check_basecamp_exist_and_crew_alive(basecamp_address);
    let basecamp = borrow_global<Basecamp>(basecamp_address);
  }

  fun unpack(basecamp_address: address){
    check_basecamp_exist_and_crew_alive(basecamp_address);
    let basecamp = borrow_global<Basecamp>(basecamp_address);
  }
  
}
