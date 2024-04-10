module basecamp::world {

    use aptos_framework::account::{Self, SignerCapability};
    use aptos_framework::event;
    use aptos_framework::object;
    use aptos_framework::randomness;
    use aptos_std::string_utils::{to_string};
    use std::option;
    use std::vector;
    use std::signer::address_of;
    use std::signer;
    use std::string::{Self, String, utf8};
    use aptos_token_objects::collection;
    use aptos_token_objects::token;

    const APP_OBJECT_SEED: vector<u8> = b"BASECAMP";
    const DISCOVERY_COLLECTION_NAME: vector<u8> = b"Basecamp Discovery Collection";
    const DISCOVERY_COLLECTION_DESCRIPTION: vector<u8> = b"Basecamp Discovery Description";
    const DISCOVERY_COLLECTION_URI: vector<u8> = b"png";

    const CREW_COLLECTION_NAME: vector<u8> = b"Basecamp Crew Collection";
    const CREW_COLLECTION_DESCRIPTION: vector<u8> = b"Basecamp Crew Description";
    const CREW_COLLECTION_URI: vector<u8> = b"png";

    const EQUIPMENT_COLLECTION_NAME: vector<u8> = b"Basecamp Store Collection";
    const EQUIPMENT_COLLECTION_DESCRIPTION: vector<u8> = b"Basecamp Store Description";
    const EQUIPMENT_COLLECTION_URI: vector<u8> = b"png";

    const MIN_RAIN: u8 = 0;
    const MAX_RAIN: u8 = 100;
    const MIN_WIND: u8 = 1;
    const MAX_WIND: u8 = 120;
    const MIN_TEMP: u8 = 30;
    const MAX_TEMP: u8 = 100;

    struct World has key {
        temp: u8,
        rain: u8,
        wind: u8,
        locations: vector<u64>
    }

    struct Encounter has key {
        id: u64,
        name: String,
        category: String,
        consumable: bool,
        live: bool,
        health: u8,
        strength: u8
    }

    struct Discovery has key {
        id: u64,
        name: String,
        category: String,
        size: u8,
    }

    struct Crew has key {
        id: u64,
        name: String,
        health: u8,
        strength: u8
    }

    struct Equipment has key {
        id: u64,
        name: String,
        category: String,
        consumable: bool,
        uses: u8,
        size: u8,
        capacity: u8,
        health: u8,
        strength: u8,
    }

    struct CollectionCapability has key {
        capability: SignerCapability,
        burn_signer_capability: SignerCapability,
    }

    struct MintDiscoveryEvents has key {
        mint_discovery_events: event::EventHandle<MintDiscoveryEvent>,
    }

    struct MintCrewEvent has drop, store {
        crew_address: address,
        token_name: String,
    }

    struct MintCrewEvents has key {
        mint_crew_events: event::EventHandle<MintCrewEvent>,
    }

    struct MintDiscoveryEvent has drop, store {
        discovery_address: address,
        token_name: String,
    }

    struct MintEquipmentEvents has key {
        mint_store_events: event::EventHandle<MintEquipmentEvent>,
    }

    struct MintEquipmentEvent has drop, store {
        equipment_address: address,
        token_name: String,
    }

    /*
    ================================
        I N I T I A L I Z E
    ================================
    */
    fun init_module(account: &signer) {

        let temp = randomness::u8_range(MIN_TEMP, MAX_TEMP);
        let rain = randomness::u8_range(MIN_RAIN, MAX_RAIN);
        let wind = randomness::u8_range(MIN_WIND, MAX_WIND);

        let locations = vector::empty<u64>();
        let world = World {
            temp: temp,
            rain: rain,
            wind: wind,
            locations: locations
        };
        move_to(account, world);

        let (token_resource, token_signer_cap) = account::create_resource_account(
            account,
            APP_OBJECT_SEED,
        );
        let (_, burn_signer_capability) = account::create_resource_account(
            account,
            APP_OBJECT_SEED,
        );

        move_to(account, CollectionCapability {
            capability: token_signer_cap,
            burn_signer_capability,
        });

        move_to(account, MintDiscoveryEvents {
            mint_discovery_events: account::new_event_handle<MintDiscoveryEvent>(account),
        });

        create_discovery_collection(&token_resource);
        create_crew_collection(&token_resource);
        create_equipment_collection(&token_resource);
    }

    fun get_token_signer(): signer acquires CollectionCapability {
        account::create_signer_with_capability(&borrow_global<CollectionCapability>(@basecamp).capability)
    }

    // ==== World ====
    fun get_weather(world_address: address): (u8, u8, u8) acquires World {
        let world = borrow_global<World>(world_address);
        (world.temp, world.rain, world.wind)
    }

    fun next_weather(world_address: address) acquires World {
        let weather = borrow_global_mut<World>(world_address);

        weather.temp = if (weather.temp < MIN_TEMP) {
            MIN_TEMP
        } else if (weather.temp > MAX_TEMP) {
            MAX_TEMP
        } else {
            randomness::u8_range(weather.temp - 5, weather.temp + 5)
        };

        weather.rain = if (weather.rain < MIN_RAIN) {
            MIN_RAIN
        } else if (weather.rain > MAX_RAIN) {
            MAX_RAIN
        } else {
            randomness::u8_range(weather.rain - 5, weather.rain + 5)
        };

        weather.wind = if (weather.wind < MIN_WIND) {
            MIN_WIND
        } else if (weather.wind > MAX_WIND) {
            MAX_WIND
        } else {
            randomness::u8_range(weather.wind - 5, weather.wind + 5)
        };

    }

    public entry fun explore(
        user: &signer, 
        world_address: address, 
        location: u64,
        crew: vector<String>
        ) acquires Crew, World, CollectionCapability {
        explore_location(user, world_address, location, crew);
        next_weather(world_address);
    }

    fun explore_location(
        user: &signer,
        world_address: address,
        location: u64,
        crew: vector<String>
        ) acquires Crew, World, CollectionCapability {
        let (temp, rain, wind) = get_weather(world_address);

        let rarity = randomness::u8_range(0, 100);
        let live_odds = randomness::u8_range(1, 10);
        if (live_odds == 1){
        } else {
        };

        let crew_id = string::utf8(b"Nick");
        let (name, health, strength) = get_crew_member(user, crew_id);

        // for each crew
        // get equipment attached to crew
        // sum strength, health
        // if there are encounters
        // determine if they are a threat
        // deal damage
        // if no encounters that deal damage
        // show discoveries
    }

    // ==== Discoveries ====
    fun create_discovery_collection(account: &signer) {
        let description = string::utf8(DISCOVERY_COLLECTION_DESCRIPTION);
        let name = string::utf8(DISCOVERY_COLLECTION_NAME);
        let uri = string::utf8(DISCOVERY_COLLECTION_URI);
        collection::create_unlimited_collection(
            account,
            description,
            name,
            option::none(),
            uri,
        );
    }

    fun mint_discovery(
        user: &signer, 
        id: u64,
        name: String,
        category: String,
        size: u8
        ) acquires CollectionCapability {
        let uri = string::utf8(DISCOVERY_COLLECTION_URI);
        let description = string::utf8(DISCOVERY_COLLECTION_DESCRIPTION);

        let constructor_ref = token::create_named_token(
            &get_token_signer(),
            string::utf8(DISCOVERY_COLLECTION_NAME),
            description,
            get_discovery_token_name(&address_of(user), category),
            option::none(),
            uri,
        );
        let token_signer = object::generate_signer(&constructor_ref);
        let transfer_ref = object::generate_transfer_ref(&constructor_ref);

        let discovery = Discovery {
            id: id,
            name: name,
            category: category,
            size: size
        };

        move_to(&token_signer, discovery);
        object::transfer_with_ref(object::generate_linear_transfer_ref(&transfer_ref), address_of(user));
    }

    fun get_discovery_token_name(owner_addr: &address, category: String): String {
        let token_name = category;
        string::append(&mut token_name, to_string(owner_addr));
        token_name
    }

    // ==== Crew ====
    fun create_crew_collection(account: &signer) {
        let description = string::utf8(CREW_COLLECTION_DESCRIPTION);
        let name = string::utf8(CREW_COLLECTION_NAME);
        let uri = string::utf8(CREW_COLLECTION_URI);
        collection::create_unlimited_collection(
            account,
            description,
            name,
            option::none(),
            uri,
        );
    }

    fun mint_crew(
        user: &signer, 
        id: u64,
        name: String,
        health: u8,
        strength: u8,
        ) acquires CollectionCapability {
        let uri = string::utf8(CREW_COLLECTION_URI);
        let description = string::utf8(CREW_COLLECTION_DESCRIPTION);

        let constructor_ref = token::create_named_token(
            &get_token_signer(),
            string::utf8(CREW_COLLECTION_NAME),
            description,
            get_equipment_token_name(&address_of(user), name),
            option::none(),
            uri,
        );
        let token_signer = object::generate_signer(&constructor_ref);
        let transfer_ref = object::generate_transfer_ref(&constructor_ref);

        let crew = Crew {
            id: id,
            name: name,
            health: health,
            strength: strength,
        };

        move_to(&token_signer, crew);
        object::transfer_with_ref(object::generate_linear_transfer_ref(&transfer_ref), address_of(user));
    }

     #[view]
    public fun get_crew_member(owner: &signer, crew_id: String): (String, u8, u8) acquires Crew, CollectionCapability {
        let token_address = get_crew_address(owner, crew_id);
        let crew = borrow_global_mut<Crew>(token_address);
        (crew.name, crew.health, crew.strength)
    }

    fun get_crew_address(owner: &signer, crew_id: String): (address) acquires CollectionCapability {
        let collection = string::utf8(b"Basecamp Crew Collection");
        let creator = &get_token_signer();
        let token_address = token::create_token_address(
            &signer::address_of(creator),
            &collection,
            &crew_id,
        );
        token_address
    }

    // ==== Equipment ====
    fun create_equipment_collection(account: &signer) {
        let description = string::utf8(EQUIPMENT_COLLECTION_DESCRIPTION);
        let name = string::utf8(EQUIPMENT_COLLECTION_NAME);
        let uri = string::utf8(EQUIPMENT_COLLECTION_URI);
        collection::create_unlimited_collection(
            account,
            description,
            name,
            option::none(),
            uri,
        );
    }

    fun mint_equipment(
        user: &signer, 
        id: u64,
        name: String,
        category: String,
        consumable: bool,
        uses: u8,
        size: u8,
        capacity: u8,
        health: u8,
        strength: u8,
        ) acquires CollectionCapability {
        let uri = string::utf8(EQUIPMENT_COLLECTION_URI);
        let description = string::utf8(EQUIPMENT_COLLECTION_DESCRIPTION);

        let constructor_ref = token::create_named_token(
            &get_token_signer(),
            string::utf8(EQUIPMENT_COLLECTION_NAME),
            description,
            get_equipment_token_name(&address_of(user), category),
            option::none(),
            uri,
        );
        let token_signer = object::generate_signer(&constructor_ref);
        let transfer_ref = object::generate_transfer_ref(&constructor_ref);

        let equipment = Equipment {
            id: id,
            name: name,
            category: category,
            consumable: consumable,
            uses: uses,
            size: size,
            capacity: capacity,
            health: health,
            strength: strength,
        };

        move_to(&token_signer, equipment);
        object::transfer_with_ref(object::generate_linear_transfer_ref(&transfer_ref), address_of(user));
    }

    fun get_equipment_token_name(owner_addr: &address, category: String): String {
        let token_name = category;
        string::append(&mut token_name, to_string(owner_addr));
        token_name
    }

    /*
    ================================
        T E S T
    ================================
    */

}