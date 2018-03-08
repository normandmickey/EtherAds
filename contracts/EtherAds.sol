pragma solidity ^0.4.18;

import 'zeppelin-solidity/contracts/token/ERC721/ERC721Token.sol';
import 'zeppelin-solidity/contracts/ownership/Ownable.sol';
import './usingOraclize.sol';

contract EtherAds is ERC721Token, Ownable {
  string constant public NAME = "EthAds";
  string constant public SYMBOL = "EAD";
  uint256 constant public PRICE = 0.0005 ether;
  uint256 public objectCount = 0;

  mapping(uint256 => uint256) tokenToPriceMap;
  mapping(uint256 => string) tokenToNameMap;
  mapping(uint256 => string) tokenToUrlMap;
  mapping(uint256 => string) tokenToImageUrlMap;

  Ad[] ads;

  struct Ad {
    string name;
    string url;
    string imageurl; 
  }

  function EtherAds() public {
    mintObject(1, "ETHEREUM", "http://www.etherads.co", "https://www.ethereum.org/images/logos/ETHEREUM-ICON_Black_small.png");
//    mintObject(2, "ICO", "http://www.etherads.co", "https://www.ethereum.org/images/logos/ETHEREUM-ICON_Black_small.png");
//    mintObject(3, "EXCHANGE", "http://www.etherads.co", "https://www.ethereum.org/images/logos/ETHEREUM-ICON_Black_small.png");//
//    mintObject(4, "BITCOIN", "http://www.etherads.co", "https://www.ethereum.org/images/logos/ETHEREUM-ICON_Black_small.png");
//    mintObject(5, "CASINO", "http://www.etherads.co", "https://www.ethereum.org/images/logos/ETHEREUM-ICON_Black_small.png");
//    mintObject(6, "AUCTION", "http://www.etherads.co", "https://www.ethereum.org/images/logos/ETHEREUM-ICON_Black_small.png");
//    mintObject(7, "WALLET", "http://www.etherads.co", "https://www.ethereum.org/images/logos/ETHEREUM-ICON_Black_small.png");
//    mintObject(8, "CRYPTO", "http://www.etherads.co", "https://www.ethereum.org/images/logos/ETHEREUM-ICON_Black_small.png");
//    mintObject(9, "GAMES", "http://www.etherads.co", "https://www.ethereum.org/images/logos/ETHEREUM-ICON_Black_small.png");
//    mintObject(10, "TOKENS", "http://www.etherads.co", "https://www.ethereum.org/images/logos/ETHEREUM-ICON_Black_small.png");
  }

  function getName() public pure returns(string) {
    return NAME;
  }

  function getSymbol() public pure returns(string) {
    return SYMBOL;
  }

  function getObjectCount() public view returns (uint256) {
    return objectCount;
  }

  function mintObject(uint256 adId, string name, string url, string imageurl) public payable onlyOwner() {
    _mint(msg.sender, adId);
    objectCount++;
    tokenToNameMap[adId] = name;
    tokenToUrlMap[adId] = url;
    tokenToPriceMap[adId] = PRICE;
    tokenToImageUrlMap[adId] = imageurl;
  }

  function buyAd(uint adId, string url, string img) public payable onlyMintedTokens(adId) {
    //require enough ether
    uint256 askingPrice = getAskingPrice(adId);
    require(msg.value >= askingPrice);

    //transfer ad ownership
    address previousOwner = ownerOf(adId);

    clearApprovalAndTransfer(previousOwner, msg.sender, adId);

    //update price
    tokenToPriceMap[adId] = askingPrice;
    tokenToUrlMap[adId] = (url);
    tokenToImageUrlMap[adId] = (img);

    //TODO: take dev cut
    uint256 pocut = getPoCut(adId);

    //send ether to previous owner
    previousOwner.transfer(pocut);
  }

  function getDevCut(uint256 adId) public view onlyMintedTokens(adId) returns(uint256) {
    uint256 askingPrice = tokenToPriceMap[adId];
    return askingPrice * 33 / 100;
  }

  function getPoCut(uint256 adId) public view onlyMintedTokens(adId) returns(uint256) {
    uint256 askingPrice = tokenToPriceMap[adId];
    return askingPrice * 67 / 100;
  }

  function getCurrentPrice(uint256 adId) public view onlyMintedTokens(adId) returns(uint256) {
    return tokenToPriceMap[adId];
  }

  function getAskingPrice(uint256 adId) public view onlyMintedTokens(adId) returns(uint256) {
    uint256 lastPrice = tokenToPriceMap[adId];
      return lastPrice * 2;
  }

  function getAd(uint256 adId) public view onlyMintedTokens(adId) returns(string, address, uint256, string, string) {
    string name = tokenToNameMap[adId];
    address owner = ownerOf(adId);
    uint256 askingPrice = getAskingPrice(adId);
    string url = tokenToUrlMap[adId];
    string imageurl = tokenToImageUrlMap[adId];
    return (name, owner, askingPrice, url, imageurl);
  }

  function withdrawEther() external onlyOwner {
    owner.transfer(this.balance);
  }

  modifier onlyMintedTokens(uint256 adId) {
    require(tokenToPriceMap[adId] != 0);
    _;
  }
}
