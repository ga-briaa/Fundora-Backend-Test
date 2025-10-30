import "dotenv/config";
import hardhatToolboxViem from "@nomicfoundation/hardhat-toolbox-viem";

import type { HardhatUserConfig } from "hardhat/config";
import { configVariable } from "hardhat/config";

const config: HardhatUserConfig = {
  plugins: [hardhatToolboxViem],

  solidity: "0.8.28",
  
  networks: {
    baseSepolia: {
      type: "http",
      chainType: "l1",
      url: configVariable("SEPOLIA_RPC_URL"),
      accounts: [configVariable("PRIVATE_KEY")],
      chainId: 84532,
    },
  },

  verify: {
    etherscan: {
      apiKey: process.env.ETHERSCAN_API_KEY,

      // customChains causing error?
      // Commented temporarily

      // customChains: [
      //   {
      //     network: "baseSepolia",
      //     chainId: 84532,
      //     urls: {
      //       // Problem
      //       // Detects the API Key as Etherscan V1
      //       // Use documentation: https://docs.etherscan.io/v2-migration
      //       apiURL: "https://api.etherscan.io/v2/api?chainid=84532",
      //       browserURL: "https://sepolia.basescan.org"
      //     }
      //   }
      // ]
    },
  }
};

export default config;