contract;

use std::{
    asset::{
        burn,
        mint_to,
        transfer,
    },
    auth::msg_sender,
    call_frames::msg_asset_id,
    constants::DEFAULT_SUB_ID,
    context::{
        msg_amount,
        this_balance,
    },
    contract_id::ContractId,
    identity::Identity,
};

abi LiquidityPool {
    #[payable]
    fn deposit();

    #[payable]
    fn withdraw();
}

impl LiquidityPool for Contract {
    #[payable]
    fn deposit() {
        // The asset being deposited must be the base asset.
        assert(msg_asset_id() == AssetId::base());
        assert(msg_amount() > 0);

        // Get the sender of the funds.
        let sender = msg_sender().unwrap();

        // Calculate how many LP tokens to mint.
        // This is a simple fixed-rate example.
        let amount_to_mint = msg_amount() * 2;

        // Mint the LP tokens to the sender.
        mint_to(sender, DEFAULT_SUB_ID, amount_to_mint);
    }

    #[payable]
    fn withdraw() {
        // Calculate the asset ID of this contract's LP token.
        let this_contract = ContractId::this();
        let lp_asset_id = AssetId::new(this_contract, DEFAULT_SUB_ID);

        // The asset being sent to the contract must be the LP token.
        assert(msg_asset_id() == lp_asset_id);
        assert(msg_amount() > 0);

        // Get the sender who is withdrawing.
        let sender = msg_sender().unwrap();

        // Burn the received LP tokens.
        burn(DEFAULT_SUB_ID, msg_amount());

        // Calculate how much of the base asset to return.
        let amount_to_transfer = msg_amount() / 2;

        // Ensure the contract has enough funds to transfer.
        assert(this_balance(AssetId::base()) >= amount_to_transfer);

        // Transfer the base asset back to the sender.
        transfer(sender, AssetId::base(), amount_to_transfer);
    }
}
