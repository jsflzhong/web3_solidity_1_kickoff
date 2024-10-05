require("@nomicfoundation/hardhat-toolbox");
require("@nomiclabs/hardhat-ethers");
require('dotenv').config();
require("hardhat-deploy");



const ALCHEMY_API_KEY = vars.get("ALCHEMY_API_KEY");

module.exports = {
  solidity: "0.8.27",
  networks: {
    hardhat: {
      gasPrice: 1,
      chainId: 43112,
    },
    sepolia: {
      url: `https://eth-sepolia.g.alchemy.com/v2/${ALCHEMY_API_KEY}`,
       // No private key here, manual signing will be done via MetaMask
    },
    mainnet: {
      url: 'https://eth-sepolia.g.alchemy.com/v2/JRgjhtIuTCtqlpQon5MkNqRnN63z0oL7',
      gasPrice: 1,
      chainId: 43114,
      accounts: [
    ]
    }
  }
};
