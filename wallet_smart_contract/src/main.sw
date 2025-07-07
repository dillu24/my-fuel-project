contract;

use std::{asset::transfer, call_frames::msg_asset_id, context::msg_amount};
use wallet_abi::Wallet;

// Define the owner's address as a b256 constant.
// This is the only way to declare a constant address value.
const OWNER: b256 = 0xE76462Eb40754d2086926972a25c4db9188c378a4efA959285eEf66c3b6a9651;
const ETH_ASSET_ID: b256 = 0xf8f8b6283d7fa5b672b530cbb84fcccb4ff8dc40f8176ef4544ddb1f1952ad07;

storage {
    // Define a storage variable to hold the contract's balance
    balance: u64 = 0,
}

impl Wallet for Contract {
    #[storage(read, write), payable]
    fn receive_funds() {
        if msg_asset_id() == AssetId::from(ETH_ASSET_ID) {
            storage.balance.write(storage.balance.read() + msg_amount());
        }
    }

    #[storage(read, write)]
    fn send_funds(amount: u64, recipient: Address) {
        let sender = msg_sender().unwrap();
        match sender {
            // Compare the sender's b256 value with the constant.
            Identity::Address(addr) => require(
                b256::from(addr) == OWNER,
                "Sender is not the contract owner",
            ),
            _ => revert(0),
        };

        let current_balance = storage.balance.read();
        require(
            current_balance >= amount,
            "Insufficient balance to send funds",
        );

        storage.balance.write(current_balance - amount);

        transfer(
            Identity::Address(recipient),
            AssetId::from(ETH_ASSET_ID),
            amount,
        );
    }
}
