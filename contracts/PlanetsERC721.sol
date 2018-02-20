pragma solidity ^0.4.18;

import 'zeppelin-solidity/contracts/token/ERC721/ERC721Token.sol';
import 'zeppelin-solidity/contracts/ownership/Ownable.sol';

contract PlanetsERC721 is ERC721Token, Ownable {
  string constant public NAME = "PLANETS";
  string constant public SYMBOL = "P";

  uint constant public PRICE = 0.005 ether;

  mapping(uint256 => uint256) tokenToPriceMap;
  Planet[] planets;

  struct Planet {
    string name;
  }

  function PlanetsERC721() public {
    _mintPlanet(1, "Mercury");
    _mintPlanet(2, "Venus");
    _mintPlanet(3, "Earth");
    _mintPlanet(4, "Mars");
    _mintPlanet(5, "Jupiter");
    _mintPlanet(6, "Saturn");
    _mintPlanet(7, "Uranus");
    _mintPlanet(8, "Neptune");
  }

  function getName() public pure returns(string) {
    return NAME;
  }

  function getSymbol() public pure returns(string) {
    return SYMBOL;
  }

  function _mintPlanet(uint256 planetId, string name) public payable {
    Planet memory _planet = Planet({
      name: name
    });
    planets.push(_planet);
    _mint(msg.sender, planetId);
    tokenToPriceMap[planetId] = PRICE;
  }

  function buyPlanet(uint planetId) public payable onlyMintedTokens(planetId) {
    //require enough ether
    uint256 askingPrice = getAskingPrice(planetId);
    require(msg.value >= askingPrice);

    //transfer planet ownership
    address previousOwner = ownerOf(planetId);
    clearApprovalAndTransfer(previousOwner, msg.sender, planetId);

    //update price
    tokenToPriceMap[planetId] = askingPrice;

    //TODO: take dev cut
    

    //send ether to previous owner
    previousOwner.transfer(msg.value);
  }

  function getCurrentPrice(uint256 planetId) public view onlyMintedTokens(planetId) returns(uint256) {
    return tokenToPriceMap[planetId];
  }

  function getAskingPrice(uint256 planetId) public view onlyMintedTokens(planetId) returns(uint256) {
    uint256 lastPrice = tokenToPriceMap[planetId];
    uint256 askingPrice = lastPrice * 2;
    return askingPrice;
  }

  modifier onlyMintedTokens(uint256 planetId) {
    require(tokenToPriceMap[planetId] != 0);
    _;
  }
}
