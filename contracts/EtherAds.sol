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
  Ad[] ads;

  struct Ad {
    string name;
  }

  function EtherAds() public {
    mintObject(1, "Position #1");
    mintObject(2, "Position #2");
    mintObject(3, "Position #3");
    mintObject(4, "Position #4");
    mintObject(5, "Position #5");
    mintObject(6, "Position #6");
    mintObject(7, "Position #7");
    mintObject(8, "Position #8");
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

  function mintObject(uint256 adId, string name) public payable onlyOwner() {
    _mint(msg.sender, adId);
    objectCount++;
    tokenToNameMap[adId] = name;
    tokenToPriceMap[adId] = PRICE;
  }

  function buyAd(uint adId) public payable onlyMintedTokens(adId) {
    //require enough ether
    uint256 askingPrice = getAskingPrice(adId);
    require(msg.value >= askingPrice);

    //transfer ad ownership
    address previousOwner = ownerOf(adId);
    clearApprovalAndTransfer(previousOwner, msg.sender, adId);

    //update price
    tokenToPriceMap[adId] = askingPrice;

    //TODO: take dev cut


    //send ether to previous owner
    previousOwner.transfer(msg.value);
  }

  function getCurrentPrice(uint256 adId) public view onlyMintedTokens(adId) returns(uint256) {
    return tokenToPriceMap[adId];
  }

  function getAskingPrice(uint256 adId) public view onlyMintedTokens(adId) returns(uint256) {
    uint256 lastPrice = tokenToPriceMap[adId];
    if (lastPrice <= 0.04 ether) {
      return lastPrice * 2;
    }
    if (lastPrice <= 0.25 ether) {
      return lastPrice * 175 / 100;
    }
    if (lastPrice <= 0.50 ether) {
      return lastPrice * 150 / 100;
    }
    if (lastPrice > 0.50 ether) {
      return lastPrice * 125 / 100;
    }
    return lastPrice;
  }

  function getAd(uint256 adId) public view onlyMintedTokens(adId) returns(string, address, uint256) {
    string name = tokenToNameMap[adId];
    address owner = ownerOf(adId);
    uint256 askingPrice = getAskingPrice(adId);
    return (name, owner, askingPrice);
  }

  modifier onlyMintedTokens(uint256 adId) {
    require(tokenToPriceMap[adId] != 0);
    _;
  }
}
