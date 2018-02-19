const tokenContract = artifacts.require('./PlanetsERC721.sol')
const BigNumber = web3.BigNumber

contract('PlanetsERC721', accounts => {
  var owner = accounts[0]
  let planets

  beforeEach(async function () {
    planets = await tokenContract.new({ from: owner })
  })

  it('has initial state', async function () {
    const name = await planets.getName()
    const symbol = await planets.getSymbol()

    assert.equal(name, "PLANETS")
    assert.equal(symbol, "P")
  })

  it('has correct owner', async function () {
    const actualOwner = await planets.owner()
    assert.equal(actualOwner, owner)
  })
})
