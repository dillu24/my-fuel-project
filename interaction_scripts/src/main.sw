script;

use wallet_abi::Wallet;
use std::address::Address;

fn main() {
    let contract_address = 0x5a1787104f99b32098374853e356cf1f0fac1473b1cdfe92ba42005bea0df67d;
    let caller = abi(Wallet, contract_address);
    let amount_to_send = 200;
    let amount_to_receive = 100;
    let recipient_address = Address::from(0xE76462Eb40754d2086926972a25c4db9188c378a4efA959285eEf66c3b6a9651);
    let eth_asset_id = 0xf8f8b6283d7fa5b672b530cbb84fcccb4ff8dc40f8176ef4544ddb1f1952ad07;
    caller
        .receive_funds {
            gas: 30000,
            coins: amount_to_send,
            asset_id: eth_asset_id,
        }();
    caller
        .send_funds(amount_to_receive, recipient_address);
}
