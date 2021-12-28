const { assert } = require('chai')

const KryptoBirdz = artifacts.require('./KryptoBirdz')

// check for chai
require('chai')
    .use(require('chai-as-promised'))
    .should()

contract('KryptoBirdz', (accounts) => {
    let contract;

    before(async () => {
        contract = await KryptoBirdz.deployed();
    })

    // testing container 
    describe('deployment', async () => {
        it('deploys successfully', async () => {
            const address = contract.address;

            assert.notEqual(address, '', "address is empty");
            assert.notEqual(address, null, "address is null");
            assert.notEqual(address, undefined, "address is undefined");
            assert.notEqual(address, 0x0, "address is 0x0 address");
        })

        it('Check name and symbol of the contract', async () => {
            const name = await contract.name();
            assert.equal(name, 'KryptoBirdz', "name is not equal");

            const symbol = await contract.symbol();
            assert.equal(symbol, 'KBIRDZ', "symbol is not equal");
        })

    })

    describe('Minting', async () => {
        it('Create new token', async () => {
            const result = await contract.mint('http...1');
            const totalSupply = await contract.totalSupply();

            assert.equal(totalSupply, 1, "totalSupply is not one");

            // take out event logs
            const event = result.logs[0].args;
            assert.equal(event._from, '0x0000000000000000000000000000000000000000', 'from is the contract');
            assert.equal(event._to, accounts[0], 'to is the msg sender')

            // failure
            await contract.mint('http...1').should.be.rejected;
        })
    })

    describe('Indexing', async () => {
        it('list kryptoBirds', async () => {
            await contract.mint('http...2')
            await contract.mint('http...3')
            await contract.mint('http...4')
            const totalSupply = await contract.totalSupply();

            // loop through the kryptoBirdz array
            let results = [];
            let kryptoBird;
            for(let i = 0; i < totalSupply; i++) {
                kryptoBird = await contract.kryptoBirdz(i);
                results.push(kryptoBird);
            }

            let expected = ['http...1', 'http...2', 'http...3', 'http...4']
            assert.equal(results.join(','), expected.join(','), 'all nft token is not equal to expected nft token')
        })
    })
})