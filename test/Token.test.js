const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Nekot Token", function () {
    let Nekot;
    let nekot;
    let owner;
    let addr1;
    let addr2;
    let addrs;

    beforeEach(async function () {
        Nekot = await ethers.getContractFactory("Nekot");
        [owner, addr1, addr2, ...addrs] = await ethers.getSigners();
        nekot = await Nekot.deploy(18, 1000000); // 1 million tokens with 18 decimals
        await nekot.deployed();
    });

    describe("Deployment", function () {
        it("Should set the right owner", async function () {
            expect(await nekot.owner()).to.equal(owner.address);
        });

        it("Should assign the total supply of tokens to the owner", async function () {
            const ownerBalance = await nekot.balanceOf(owner.address);
            expect(await nekot.totalSupply()).to.equal(ownerBalance);
        });

        it("Should set the correct token name and symbol", async function () {
            expect(await nekot.name()).to.equal("Nekot");
            expect(await nekot.symbol()).to.equal("NKT");
        });
    });

    describe("Transactions", function () {
        it("Should transfer tokens between accounts", async function () {
            await nekot.transfer(addr1.address, 50);
            const addr1Balance = await nekot.balanceOf(addr1.address);
            expect(addr1Balance).to.equal(50);

            await nekot.connect(addr1).transfer(addr2.address, 50);
            const addr2Balance = await nekot.balanceOf(addr2.address);
            expect(addr2Balance).to.equal(50);
        });

        it("Should fail if sender doesn't have enough tokens", async function () {
            const initialOwnerBalance = await nekot.balanceOf(owner.address);
            await expect(
                nekot.connect(addr1).transfer(owner.address, 1)
            ).to.be.revertedWith("Nekot: insufficient balance");
            expect(await nekot.balanceOf(owner.address)).to.equal(
                initialOwnerBalance
            );
        });
    });

    describe("Allowances", function () {
        it("Should approve address to spend tokens", async function () {
            await nekot.approve(addr1.address, 100);
            expect(
                await nekot.allowance(owner.address, addr1.address)
            ).to.equal(100);
        });

        it("Should transfer tokens using allowance", async function () {
            await nekot.approve(addr1.address, 100);
            await nekot
                .connect(addr1)
                .transferFrom(owner.address, addr2.address, 100);
            expect(await nekot.balanceOf(addr2.address)).to.equal(100);
        });
    });

    describe("Minting", function () {
        it("Should mint tokens", async function () {
            const initialSupply = await nekot.totalSupply();
            await nekot.mint(addr1.address, 1000);
            expect(await nekot.totalSupply()).to.equal(initialSupply.add(1000));
            expect(await nekot.balanceOf(addr1.address)).to.equal(1000);
        });

        it("Should fail if non-owner tries to mint", async function () {
            await expect(
                nekot.connect(addr1).mint(addr2.address, 1000)
            ).to.be.revertedWith("Nekot: caller is not the owner");
        });
    });

    describe("Burning", function () {
        it("Should burn tokens", async function () {
            await nekot.transfer(addr1.address, 1000);
            const initialSupply = await nekot.totalSupply();
            await nekot.connect(addr1).burn(500);
            expect(await nekot.totalSupply()).to.equal(initialSupply.sub(500));
            expect(await nekot.balanceOf(addr1.address)).to.equal(500);
        });
    });

    describe("Pausing", function () {
        it("Should pause and unpause", async function () {
            await nekot.pause();
            await expect(nekot.transfer(addr1.address, 100)).to.be.revertedWith(
                "Nekot: token operations are paused"
            );

            await nekot.unpause();
            await nekot.transfer(addr1.address, 100);
            expect(await nekot.balanceOf(addr1.address)).to.equal(100);
        });
    });
});
