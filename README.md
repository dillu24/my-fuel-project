**Deploy contract**:

```
Call contract: forc call \
  0xdb6d053e8d2f4f0a33cc4d3d0b35ed5fdbdf5f7badee160267045b62568a08f7 \
  fizzbuzz \
  22 \
  --testnet \
--abi ./out/debug/my-fuel-project-abi.json
```

**List of tools**: `forc plugins`

**Run node in memory with default chain config**: `fuel-core run --db-type in-memory` 

**Deploy code to testnet**: `forc deploy --testnet`
