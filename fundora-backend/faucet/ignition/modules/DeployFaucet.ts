import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";
import { parseUnits } from "ethers";

const FaucetModule = buildModule("FaucetModule", (m) => {
  // m.getAccount(0) gets the first account (your deployer)
  const deployer = m.getAccount(0);

  const mockUSDC = m.contract("MockUSDC", [deployer]);

  const faucet = m.contract("Faucet", [mockUSDC, deployer]);

  const transferAmount = parseUnits("5000000", 6);

  // We call the `transfer` function on the `mockUSDC` contract.
  m.call(mockUSDC, "transfer", [faucet, transferAmount], {
    after: [faucet],
  });

  // Return the deployed contract objects
  return { mockUSDC, faucet };
});

export default FaucetModule;