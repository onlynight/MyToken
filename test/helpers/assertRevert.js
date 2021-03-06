module.exports = {
    assertRevert: async (promise) => {
        try{
            await promise;
        } catch(error) {
            const revertFound = error.message.search("revert") >= 0;
            assert(revertFound, `Expected "revert", got ${error} instead`);
        }
        assert.fail('Expected revert not received');
    },
};