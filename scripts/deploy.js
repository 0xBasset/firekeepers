const hre = require("hardhat");


async function deploy(contractName, nonce) {
  console.log("Deploying", contractName)
  const Factory = await hre.ethers.getContractFactory(contractName);
  let impl = await Factory.deploy({nonce: nonce});
  console.log(impl.address)
  return impl
}

async function deployProxied(contractName, nonce) {
  console.log("Deploying", contractName)
  const Factory = await hre.ethers.getContractFactory(contractName);
  let impl = await Factory.deploy({nonce: nonce});
  nonce++
  console.log(impl.address)

  console.log("Deploying Proxy")
  const ProxyFac = await hre.ethers.getContractFactory("Proxy");
  let proxy = await ProxyFac.deploy(impl.address, {nonce: nonce});
  console.log(proxy.address)

  await proxy.deployed();

  let a = await hre.ethers.getContractAt(contractName, proxy.address);
  return a;
}


async function main() {
  await hre.run("compile");

  let nonce = 3;

  let fire = await deployProxied("Firekeepers", nonce);
  nonce += 2;

  const Factory = await hre.ethers.getContractFactory("GelatoResolver");
  let res = await Factory.deploy(fire.address, {nonce: nonce});
  console.log("resolver", res.address);

  nonce++;

  await fire.initialize("Firekeepers", "FRKP", 75, 750);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
