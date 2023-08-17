# Sample Hardhat Project

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, and a script that deploys that contract.

Try running some of the following tasks:

```shell
npx hardhat help
npx hardhat test
REPORT_GAS=true npx hardhat test
npx hardhat node
npx hardhat run scripts/deploy.ts
```

## Deplyed to
Mumbi: 0xcB85827970d66251e660702E6C43b378950A4E71
Owner: 0x9EAbf288a308a46Ea37009132886228BF476Eb7F

Next step:
* Add token A and token B liquidity to the pool on Mumbi
* Should call approve on the token contract to allow the router to transfer tokens on behalf of the user
* Or maybe rewrite the pool contract so we don't need to call approve
* We could do this by creating a internal ledger for each user, so add 



### NO, the thing we do is expand so that after every mint call. You also call the approve function on the token contract. That way, the CCIP router can transfer tokens on behalf of the user.

