const hre = require("hardhat");


async function deploy(contractName, nonce) {
  console.log("Deploying", contractName)
  const Factory = await hre.ethers.getContractFactory(contractName);
  let impl = await Factory.deploy({nonce: nonce});
  console.log(impl.address)
  return impl
}


async function main() {
  await hre.run("compile");

  let nonce = 1;

  console.log("Deploying")
  const Factory = await hre.ethers.getContractFactory("Firekeepers");
  let impl = await Factory.deploy("Firekeepers", "FRKP", 75, 21600, {nonce: nonce});
  console.log(impl.address)

  nonce++;
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
