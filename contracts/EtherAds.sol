pragma solidity ^0.4.18;

import 'zeppelin-solidity/contracts/token/ERC721/ERC721Token.sol';
import 'zeppelin-solidity/contracts/ownership/Ownable.sol';

contract EtherAds is ERC721Token, Ownable {
  string constant public NAME = "EthAds";
  string constant public SYMBOL = "EAD";
  uint256 constant public PRICE = 0.005 ether;
  uint256 public objectCount = 0;

  mapping(uint256 => uint256) tokenToPriceMap;
  mapping(uint256 => string) tokenToNameMap;
  mapping(uint256 => string) tokenToUrlMap;
  mapping(uint256 => string) tokenToDescriptionMap;
  mapping(uint256 => string) tokenToImageUrlMap;

  Ad[] ads;

  struct Ad {
    string name;
    string url;
    string description;
    string imageurl;
  }

  function EtherAds() public {
    mintObject(1, "CASINO", "http://www.etherads.co", "casino", "https://www.ethereum.org/images/logos/ETHEREUM-ICON_Black_small.png");
    mintObject(2, "ICO", "http://www.etherads.co", "ico", "https://www.ethereum.org/images/logos/ETHEREUM-ICON_Black_small.png");
    mintObject(3, "SEX", "http://www.etherads.co", "sex", "https://www.ethereum.org/images/logos/ETHEREUM-ICON_Black_small.png");
    mintObject(4, "BITCOIN", "http://www.etherads.co", "bitcoin", "https://www.ethereum.org/images/logos/ETHEREUM-ICON_Black_small.png");
    mintObject(5, "ETHEREUM", "http://www.etherads.co", "ethereum", "https://www.ethereum.org/images/logos/ETHEREUM-ICON_Black_small.png");
    mintObject(6, "AUCTION", "http://www.etherads.co", "auction", "https://www.ethereum.org/images/logos/ETHEREUM-ICON_Black_small.png");
    mintObject(7, "WALLET", "http://www.etherads.co", "wallet", "https://www.ethereum.org/images/logos/ETHEREUM-ICON_Black_small.png");
    mintObject(8, "CRYPTO", "http://www.etherads.co", "crypto", "https://www.ethereum.org/images/logos/ETHEREUM-ICON_Black_small.png");
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

  function mintObject(uint256 adId, string name, string url, string description, string imageurl) public payable onlyOwner() {
    _mint(msg.sender, adId);
    objectCount++;
    tokenToNameMap[adId] = name;
    tokenToUrlMap[adId] = url;
    tokenToPriceMap[adId] = PRICE;
    tokenToDescriptionMap[adId] = description;
    tokenToImageUrlMap[adId] = imageurl;
  }

  function buyAd(uint adId, string url) public payable onlyMintedTokens(adId) {
    //require enough ether
    uint256 askingPrice = getAskingPrice(adId);
    require(msg.value >= askingPrice);

    //transfer ad ownership
    address previousOwner = ownerOf(adId);
    clearApprovalAndTransfer(previousOwner, msg.sender, adId);

    //update price
    tokenToPriceMap[adId] = askingPrice;
    tokenToUrlMap[adId] = (url);

    //TODO: take dev cut


    //send ether to previous owner
    previousOwner.transfer(msg.value);
  }

  function getCurrentPrice(uint256 adId) public view onlyMintedTokens(adId) returns(uint256) {
    return tokenToPriceMap[adId];
  }

  function getAskingPrice(uint256 adId) public view onlyMintedTokens(adId) returns(uint256) {
    uint256 lastPrice = tokenToPriceMap[adId];
//    if (lastPrice <= 0.04 ether) {
      return lastPrice * 2;
//    }
//    if (lastPrice <= 0.25 ether) {
//      return lastPrice * 2 ;
//    }
//    if (lastPrice <= 0.50 ether) {
//      return lastPrice * 2;
//    }
//    if (lastPrice > 0.50 ether) {
//      return lastPrice * 2;
//   }
//    return lastPrice;
  }

  function getAd(uint256 adId) public view onlyMintedTokens(adId) returns(string, address, uint256, string, string, string) {
    string name = tokenToNameMap[adId];
    address owner = ownerOf(adId);
    uint256 askingPrice = getAskingPrice(adId);
    string url = tokenToUrlMap[adId];
    string description = tokenToDescriptionMap[adId];
    string imageurl = tokenToImageUrlMap[adId];
    return (name, owner, askingPrice, url, description, imageurl);
  }

  modifier onlyMintedTokens(uint256 adId) {
    require(tokenToPriceMap[adId] != 0);
    _;
  }
}
