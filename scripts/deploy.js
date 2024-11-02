const hre = require("hardhat");

async function main() {
    const Nekot = await hre.ethers.getContractFactory("Nekot");

    // Deploy with 1 million tokens and 18 decimals
    const nekot = await Nekot.deploy(18, 1000000);
    await nekot.deployed();

    console.log("Nekot token deployed to:", nekot.address);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
