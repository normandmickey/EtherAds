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
      App.web3Provider = new Web3.providers.HttpProvider('http://127.0.0.1:8545');
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

  getPlanets: function() {
    var planetsContractInstance;

    web3.eth.getAccounts(function(error, accounts) {
      if (error) {
        console.log(error);
      }

      var account = accounts[0];
      App.contracts.PlanetsERC721.deployed().then(function(instance) {
        planetsContractInstance = instance;
        let planets = [1,2,3,4,5,6,7,8];
        planets.forEach(function(id) {
          return planetsContractInstance.getPlanet(id).then((result) => {
            App.addPlanetSection(result, id);
          })
        })
      }).catch(function(err) {
        console.log(err.message);
      });
    })
  },

  buyPlanet: function(planetId, price) {
    App.contracts.PlanetsERC721.deployed().then(function(instance) {
      instance.buyPlanet(planetId, { value: price} )
    })
  },

  addPlanetSection: function(planetInfo, id) {
    let mainElement = document.createElement('div')
    mainElement.id = "planet-container"
    let textElement = document.createElement('p')
    textElement.innerText = planetInfo;
    let buyPlanetButton = document.createElement("BUTTON")
    buyPlanetButton.class = "buyPlanetButton"
    buyPlanetButton.addEventListener('click', function() {
      App.buyPlanet(id, planetInfo[2])
    })
    mainElement.appendChild(textElement)
    mainElement.appendChild(buyPlanetButton)
    document.querySelector('#planets-container').appendChild(mainElement)
  },

};

$(function() {
  $(window).load(function() {
    App.init();
  });
});
