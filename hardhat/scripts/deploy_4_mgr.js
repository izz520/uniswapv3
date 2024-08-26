// This is a script for deploying your contracts. You can adapt it to deploy
// yours, or create new ones.

async function main() {
    // This is just a convenience check
    if (network.name === "hardhat") {
        console.warn(
            "You are trying to deploy a contract to the Hardhat Network, which" +
            "gets automatically created and destroyed every time. Use the Hardhat" +
            " option '--network localhost'"
        );
    }

    // ethers is available in the global scope
    const [deployer] = await ethers.getSigners();
    console.log(
        "Deploying the contracts with the account:",
        await deployer.getAddress()
    );

    console.log("Account balance:", (await deployer.getBalance()).toString());

    //solidity version：0.8.18

    //发布仓位描述
    const Mgr = await ethers.getContractFactory("NonfungiblePositionManager");
    //第一步的factory合约地址，weth9合约地址，第三步的仓位描述合约地址
    const mgr = await Mgr.deploy('0xb9007B12cf82deB5F950888869567E0a149fA267','0xFa0EE543211B5D0A0EC00a0740F47889aD3DaC32','0x078e99b171c3531c5BC9134786A1FbDD5357a3dA');
    await mgr.deployed(); //等的确认发布

    console.log("NonfungiblePositionManager address:", mgr.address);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
