import {ethers} from "hardhat";


const CCIP_POLY_MUMBAI_ROUTER_ADDRESS = "0x70499c328e1E2a3c41108bd3730F6670a44595D1";
const TOKEN_A_ADDRESS = "0x90cd17c724fabe1efbf42f6a331b66d3732ebbca";
const TOKEN_B_ADDRESS = "0x6bc69fb93282aabded7c30fdb27d1795ea866d3f";

async function main() {

  const pool = await ethers.deployContract("SimpleLiquidityPool", [TOKEN_A_ADDRESS, TOKEN_B_ADDRESS, CCIP_POLY_MUMBAI_ROUTER_ADDRESS], {});

  await pool.waitForDeployment();

  console.log(`deployed to ${pool.target}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });
