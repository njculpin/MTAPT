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

        let (live, gold, weather, location, store_items, owned_items) = basecamp::get_basecamp(basecamp_address);

        debug::print(&string::utf8(b"Live: "));
        debug::print(&live);

        debug::print(&string::utf8(b"Gold: "));
        debug::print(&gold);

        debug::print(&string::utf8(b"Weather: "));
        debug::print(&weather);

        debug::print(&string::utf8(b"Location: "));
        debug::print(&location);

        debug::print(&string::utf8(b"Store Items: "));
        debug::print(&store_items);

        debug::print(&string::utf8(b"Owned Items: "));
        debug::print(&owned_items);
    }
}