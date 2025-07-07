use fuels::{prelude::*, types::ContractId};

// Load the contract's JSON ABI
abigen!(Contract(name="Wallet", abi="out/debug/my-fuel-project-abi.json"));

async fn get_contract_instance() -> (Wallet<Wallet<Provider>>, ContractId) {
    // Launch a provider instance against the testnet
    let provider = Provider::connect("https://testnet.fuel.network").await.unwrap();

    // You'll need to get a wallet with testnet funds from the faucet
    // https://faucet-testnet.fuel.network/
    // And import it into your test environment, e.g. via a private key
    let secret = "YOUR_WALLET_SECRET_KEY_WITH_TESTNET_FUNDS";
    let wallet = WalletUnlocked::new_from_private_key(secret.parse().unwrap(), Some(provider));

    // Paste your deployed contract ID here
    let contract_id: ContractId = "0x...".parse().unwrap();

    let instance = Wallet::new(contract_id.clone(), wallet.clone());

    (instance, contract_id.into())
}

#[tokio::test]
async fn can_receive_and_send_funds() {
    let (instance, _id) = get_contract_instance().await;

    // Define the amount to send
    let send_amount = 100_000;

    // 1. Send funds to the contract
    let _receipts = instance
        .methods()
        .receive_funds()
        .call_params(CallParameters::new(Some(send_amount), None, None))
        .unwrap()
        .call()
        .await
        .unwrap();

    // 2. Send funds from the contract to another address
    let recipient_address = WalletUnlocked::new_random(None).address().into();
    let _receipts = instance
        .methods()
        .send_funds(send_amount, recipient_address)
        .call()
        .await
        .unwrap();

    // This is a basic test. A more complete test would check
    // the contract's balance before and after each transaction.
}
