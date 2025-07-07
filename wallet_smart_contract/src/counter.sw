contract;

abi TestContract {
    #[storage(write)]
    fn initialize_counter(initial_value: u64) -> u64;

    #[storage(read, write)]
    fn increment_counter(amount: u64) -> u64;
}

storage {
    // Define a storage variable to hold the counter value
    counter: u64 = 0,
}

impl TestContract for Contract {
    #[storage(write)]
    fn initialize_counter(initial_value: u64) -> u64 {
        // Initialize the counter with the provided value
        storage.counter.write(initial_value);
        initial_value
    }

    #[storage(read, write)]
    fn increment_counter(amount: u64) -> u64 {
        let new_value: u64 = storage.counter.read() + amount;
        storage.counter.write(new_value);
        new_value
    }
}
