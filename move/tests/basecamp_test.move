module basecamp::basecamp_test {

    #[test_only]
    use basecamp::basecamp;

    #[test_only]
    use aptos_framework::account;

    #[test_only]
    use std::signer;

    #[test_only]
    use std::string;

    #[test_only]
    use aptos_framework::randomness;

    #[test_only]
    use std::debug;

    #[test_only]
    fun setup_test(
        basecamp: &signer,
        aptos_fx: &signer,
        sender: &signer,
    ){
        randomness::initialize_for_testing(aptos_fx);
        randomness::set_seed(x"0000000000000000000000000000000000000000000000000000000000000000");
        debug::print(&string::utf8(b"Randomness setup"));

        basecamp::init_module_for_testing(basecamp);
        debug::print(&string::utf8(b"Initalized"));

        account::create_account_for_test(signer::address_of(aptos_fx));
        account::create_account_for_test(signer::address_of(sender));
        debug::print(&string::utf8(b"Accounts created"));
    }

    #[test(
        basecamp = @basecamp,
        aptos_fx = @aptos_framework,
        sender = @0xA001
    )]
    fun create_basecamp(
        basecamp: &signer,
        aptos_fx: &signer,
        sender: &signer,
    ){
        setup_test(basecamp, aptos_fx, sender);
        let basecamp_address = basecamp::create_basecamp_internal_for_testing(sender, 5);

        debug::print(&string::utf8(b"Basecamp Address"));
        debug::print(&basecamp_address);

        let owned_items = basecamp::get_basecamp_owned_items(basecamp_address);
        debug::print(&string::utf8(b"owned_items: "));
        debug::print(&owned_items);

        let store_items = basecamp::get_basecamp_store_items(basecamp_address);
        debug::print(&string::utf8(b"store_items: "));
        debug::print(&store_items);

        let location = basecamp::get_basecamp_location(basecamp_address);
        debug::print(&string::utf8(b"location: "));
        debug::print(&location);

        let weather = basecamp::get_basecamp_weather(basecamp_address);
        debug::print(&string::utf8(b"weather: "));
        debug::print(&weather);

        let crew = basecamp::get_basecamp_crew(basecamp_address);
        debug::print(&string::utf8(b"crew: "));
        debug::print(&crew);

        let gold = basecamp::get_basecamp_gold_count(basecamp_address);
        debug::print(&string::utf8(b"gold: "));
        debug::print(&gold);

        let live = basecamp::get_basecamp_live_status(basecamp_address);
        debug::print(&string::utf8(b"live: "));
        debug::print(&live);

        let world = basecamp::get_world_map(basecamp_address);
        debug::print(&string::utf8(b"world: "));
        debug::print(&world);
    }
}