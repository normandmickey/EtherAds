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
      App.web3Provider = new Web3.providers.HttpProvider('http://ethereumauction.net:8545');
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

  buyAd: function(adId, price, url, img) {
    App.contracts.EtherAds.deployed().then(function(instance) {
      instance.buyAd(adId, url, img, { value: price})
    })
  },

  addAdSection: function(adInfo, id) {
    let mainElement = document.createElement('tr')
    mainElement.className = "ad-row"
    let rowElement1 = document.createElement('td')
// new url form
    let rowElement4 = document.createElement('td')
    let newurlForm = document.createElement("FORM")
      newurlForm.setAttribute("name", "newurlForm")
       y = document.createElement("INPUT")
       y.setAttribute("type", "text")
       y.setAttribute("value", `Include http:// or https://`)
       y.setAttribute("id", "newurl"+id)
// new image source form
    let rowElement6 = document.createElement('td')
    let newimgForm = document.createElement("FORM")
      newurlForm.setAttribute("name", "newimgForm")
       z = document.createElement("INPUT")
       z.setAttribute("type", "text")
       z.setAttribute("value", `Include http:// or https://`)
       z.setAttribute("id", "newimg"+id)
// address button
    let addressButton = document.createElement("BUTTON")
    addressButton.innerText = `Owner`
    addressButton.class = "buyAdButton"
    addressButton.addEventListener('click', function redirect() {
      window.open(`https://rinkeby.etherscan.io/address/${adInfo[1]}`, "_blank")
    })
    let rowElement2 = document.createElement('td')
    let visitButton = document.createElement("BUTTON")
    visitButton.innerText = `${adInfo[0]}`
    visitButton.class = "buyAdButton"
    visitButton.addEventListener('click', function() {
      window.open(adInfo[3], "_blank")
    })
    let rowElement3 = document.createElement('td')
    let rowElement5 = document.createElement('td')
    let imageurl = document.createElement("img")
        imageurl.src = adInfo[5]
        imageurl.height = 100
        imageurl.width = 100
    let buyAdButton = document.createElement("BUTTON")
    buyAdButton.innerText = `Buy - ${web3.fromWei(adInfo[2], "ether")} ETH `
    buyAdButton.class = "buyAdButton"
    buyAdButton.addEventListener('click', function() {
      App.buyAd(id, adInfo[2], document.getElementById("newurl"+id).value, document.getElementById("newimg"+id).value)
    })
    rowElement3.appendChild(buyAdButton)
    rowElement2.appendChild(visitButton)
    rowElement4.appendChild(newurlForm)
    rowElement4.appendChild(y)
    rowElement5.appendChild(imageurl)
    rowElement6.appendChild(newimgForm)
    rowElement6.appendChild(z)
    rowElement1.appendChild(addressButton)
    mainElement.appendChild(rowElement5)
    mainElement.appendChild(rowElement2)
    mainElement.appendChild(rowElement1)
    mainElement.appendChild(rowElement3)
    mainElement.appendChild(rowElement4)
    mainElement.appendChild(rowElement6)
    document.querySelector('#ads-table').appendChild(mainElement)
  },

};

$(function() {
  $(window).load(function() {
    App.init();
  });
});
