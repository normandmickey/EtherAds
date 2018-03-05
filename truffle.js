var HDWalletProvider = require("truffle-hdwallet-provider");
var mnemonic = "food essence security cradle day desk market muscle analyst board nurse require";

module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // for more about customizing your Truffle configuration!
  networks: {
    development: {
//      host: "localhost",
//      port: 8545,
//      network_id: "4", // Match any network id
//      from: '0x9758238291b3fadb9a9488698965d38b8f3bf4ac'
//    },
      provider: function() {
        return new HDWalletProvider(mnemonic, "https://rinkeby.infura.io/CBUqbtyGQ7sgv0xozfry")
      },
      network_id: 4
    },
    mainnet: {
      provider: function() {
        return new HDWalletProvider(mnemonic, "https://mainnet.infura.io/CBUqbtyGQ7sgv0xozfry")
      },
      network_id: 1
    }   
  }
};
