const {
    assertRevert
} = require("../helpers/assertRevert");

const EIP20Abstraction = artifacts.require("EIP20");
let HST;

contract("EIP20", (accounts) => {
    beforeEach(async () => {
        HST = await EIP20Abstraction.new(10000, "Simon Bucks", 1, "SBX", {
            from: accounts[0]
        });
    });

    it('creation: should create an initial balance of 10000 for the creator', async () => {
        const balance = await HST.balanceOf.call(accounts[0]);
        assert.strictEqual(balance.toNumber(), 10000);
    });

    it('creation: test correct setting of vanity infomation', async () => {
        const name = await HST.name.call();
        assert.strictEqual(name, "Simon Bucks");

        const decimals = await HST.decimals.call();
        assert.strictEqual(decimals.toNumber(), 1);

        const symbol = await HST.symbol.call();
        assert.strictEqual(symbol, "SBX");
    });

    it('creation: should succeed in creating over 2^256 - 1 (max) tokens', async () => {
        // you can use python to create this number ( 2 ** 256 - 1 )
        const HST2 = await EIP20Abstraction.new('115792089237316195423570985008687907853269984665640564039457584007913129639935', 'Simon Bucks', 1, "SBX", {
            from: accounts[0]
        });
        const totalSupply = await HST2.totalSupply();
        const match = totalSupply.equals('115792089237316195423570985008687907853269984665640564039457584007913129639935');
        assert(match, "result is not correct");
    });

    it('transfers: send tokens to self account', async () => {
        const balanceBefore = await HST.balanceOf.call(accounts[0]);
        assert.strictEqual(balanceBefore.toNumber(), 10000);

        // await assertRevert(new Promise((resolve, reject) => {
        // 	web3.eth.sendTransaction({
        // 		from: accounts[0],
        // 		to: HST.address,
        // 		value: web3.toWei('10', 'Ether')
        // 	}, (err, res) => {
        // 		if (err) {
        // 			reject(err);
        // 		}
        // 		resolve(res);
        // 	});
        // }));

        const balanceAfter = await HST.balanceOf.call(accounts[0]);
        assert.strictEqual(balanceAfter.toNumber(), 10000);
    });

    it('transfers: should transfer 10000 tokens to accounts[1] with accounts[0] having 10000', async () => {
        await HST.transfer(accounts[1], 10000, { from: accounts[0] });
        const balance = await HST.balanceOf.call(accounts[1]);
        assert.strictEqual(balance.toNumber(), 10000);
    });

    it('transfers: should fail when transfer 10001 tokens to accounts[1] with accounts[0] having 10000', async () => {
        await assertRevert(HST.transfer.call(accounts[1], 10001, { from: accounts[0] }));
    });

    it('transfers: should handle zero-transfer normally', async () => {
        assert(await HST.transfer(accounts[1], 0, { from: accounts[0] }), "zero-transfer has fail");
    });

    it('approvals: msg.sender should approve 100 to accounts[0]', async () => {
        await HST.approve(accounts[1], 100, { from: accounts[0] });
        const allowance = await HST.allowance.call(accounts[0], accounts[1]);
        assert.strictEqual(allowance.toNumber(), 100);
    });

    it('approvals: ', );
});