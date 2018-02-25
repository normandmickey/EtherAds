App = {
  web3Provider: null,
  contracts: {},

  init: function() {
    return App.initWeb3();
  },

  initWeb3: function() {
    // Initialize web3 and set the provider to the testRPC.
    if (typeof web3 !== 'undefined') {
      App.web3Provider = web3.currentProvider;
      web3 = new Web3(web3.currentProvider);
    } else {
      // set the provider you want from Web3.providers
      App.web3Provider = new Web3.providers.HttpProvider('http://www.ethereumauction.net8545');
      web3 = new Web3(App.web3Provider);
    }

    return App.initContract();
  },

  initContract: function() {
    $.getJSON('PlanetsERC721.json', function(data) {
      // Get the necessary contract artifact file and instantiate it with truffle-contract.
      var PlanetsERC721Artifact = data;
      App.contracts.PlanetsERC721 = TruffleContract(PlanetsERC721Artifact);

      // Set the provider for our contract.
      App.contracts.PlanetsERC721.setProvider(App.web3Provider);

      return App.getPlanets();
    });

    return App.bindEvents();
  },

  bindEvents: function() {
    //$(document).on('click', '#transferButton', App.handleTransfer);
  },

  getPlanets: async function() {
    let planetsContractInstance = await App.contracts.PlanetsERC721.deployed()
    let objectCount = await planetsContractInstance.getObjectCount()
    console.log(objectCount.toNumber())
    for (let id = 1; id <= objectCount; id++) {
      console.log(id)
      planetsContractInstance.getPlanet(id).then((result) => {
        App.addPlanetSection(result, id);
      })
    }
  },

  buyPlanet: function(planetId, price) {
    App.contracts.PlanetsERC721.deployed().then(function(instance) {
      instance.buyPlanet(planetId, { value: price} )
    })
  },

  addPlanetSection: function(planetInfo, id) {
    let mainElement = document.createElement('tr')
    mainElement.className = "planet-row"
    let rowElement1 = document.createElement('td')
    rowElement1.innerText = planetInfo[0];
    let rowElement2 = document.createElement('td')
    rowElement2.innerText = planetInfo[1];
    let rowElement3 = document.createElement('td')
    rowElement3.innerText = `${web3.fromWei(planetInfo[2], "ether")} ETH`;
    let rowElement4 = document.createElement('td')
    let buyPlanetButton = document.createElement("BUTTON")
    buyPlanetButton.innerText = `Buy ${planetInfo[0]}`
    buyPlanetButton.class = "buyPlanetButton"
    buyPlanetButton.addEventListener('click', function() {
      App.buyPlanet(id, planetInfo[2])
    })
    rowElement4.appendChild(buyPlanetButton)
    mainElement.appendChild(rowElement1)
    mainElement.appendChild(rowElement2)
    mainElement.appendChild(rowElement3)
    mainElement.appendChild(rowElement4)
    document.querySelector('#planets-table').appendChild(mainElement)
  },

};

$(function() {
  $(window).load(function() {
    App.init();
  });
});
