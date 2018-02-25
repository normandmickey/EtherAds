module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // for more about customizing your Truffle configuration!
  networks: {
    development: {
      host: "127.0.0.1",
      port: 8545,
      network_id: "4", // Match any network id
      from: '0x9758238291b3fadb9a9488698965d38b8f3bf4ac'
    }
  }
};
