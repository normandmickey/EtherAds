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
    $.getJSON('EtherAds.json', function(data) {
      // Get the necessary contract artifact file and instantiate it with truffle-contract.
      var EtherAdsArtifact = data;
      App.contracts.EtherAds = TruffleContract(EtherAdsArtifact);

      // Set the provider for our contract.
      App.contracts.EtherAds.setProvider(App.web3Provider);

      return App.getAds();
    });

    return App.bindEvents();
  },

  bindEvents: function() {
    //$(document).on('click', '#transferButton', App.handleTransfer);
  },

  getAds: async function() {
    let adsContractInstance = await App.contracts.EtherAds.deployed()
    let objectCount = await adsContractInstance.getObjectCount()
    console.log(objectCount.toNumber())
    for (let id = 1; id <= objectCount; id++) {
      console.log(id)
      adsContractInstance.getAd(id).then((result) => {
        App.addAdSection(result, id);
      })
    }
  },

  buyAd: function(adId, price, url) {
    App.contracts.EtherAds.deployed().then(function(instance) {
      instance.buyAd(adId, url, { value: price})
    })
  },

  addAdSection: function(adInfo, id) {
    let mainElement = document.createElement('tr')
    mainElement.className = "ad-row"
    let rowElement1 = document.createElement('td')
//    rowElement1.innerText = adInfo[1];
    let addressButton = document.createElement("BUTTON")
    addressButton.innerText = `Owner`
    addressButton.class = "buyAdButton"
    addressButton.addEventListener('click', function redirect() {
      window.location = `https://rinkeby.etherscan.io/address/${adInfo[1]}`
    })
    let rowElement2 = document.createElement('td')
    let visitButton = document.createElement("BUTTON")
    visitButton.innerText = `${adInfo[3]}`
    visitButton.class = "buyAdButton"
    visitButton.addEventListener('click', function() {
      window.location = adInfo[3]
    })
    let rowElement3 = document.createElement('td')
    rowElement3.innerText = `${web3.fromWei(adInfo[2], "ether")} ETH`;
    let rowElement4 = document.createElement('td')
    let buyAdButton = document.createElement("BUTTON")
    buyAdButton.innerText = `Buy ${adInfo[0]} ${web3.fromWei(adInfo[2], "ether")} ETH `
    buyAdButton.class = "buyAdButton"
    buyAdButton.addEventListener('click', function() {
      App.buyAd(id, adInfo[2], "http://www.etherads.co")
    })
    rowElement4.appendChild(buyAdButton)
    rowElement2.appendChild(visitButton)
    rowElement1.appendChild(addressButton)
    mainElement.appendChild(rowElement1)
    mainElement.appendChild(rowElement2)
//    mainElement.appendChild(rowElement3)
    mainElement.appendChild(rowElement4)
    document.querySelector('#ads-table').appendChild(mainElement)
  },

};

$(function() {
  $(window).load(function() {
    App.init();
  });
});
