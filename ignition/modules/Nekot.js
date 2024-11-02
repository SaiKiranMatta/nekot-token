const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("NekotModule", (m) => {
    const nekot = m.contract("Nekot", [18, 1000000]);
    return { nekot };
});
