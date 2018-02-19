pragma solidity ^0.4.18;

import 'zeppelin-solidity/contracts/token/ERC721/ERC721Token.sol';
import 'zeppelin-solidity/contracts/ownership/Ownable.sol';

contract PlanetsERC721 is ERC721Token, Ownable {
  string constant public NAME = "PLANETS";
  string constant public SYMBOL = "P";

  uint constant public PRICE = .001 ether;

  mapping(uint256 => uint256) tokenToPriceMap;
  Planet[] planets;

  struct Planet {
    string name;
  }

  function PlanetsERC721() public {
    mintPlanet(1, "Mercury");
    mintPlanet(2, "Venus");
    mintPlanet(3, "Earth");
    mintPlanet(4, "Mars");
    mintPlanet(5, "Jupiter");
    mintPlanet(6, "Saturn");
    mintPlanet(7, "Uranus");
    mintPlanet(8, "Neptune");
  }

  function getName() public pure returns(string) {
    return NAME;
  }

  function getSymbol() public pure returns(string) {
    return SYMBOL;
  }

  function mintPlanet(uint256 planetId, string name) public payable {
    Planet memory _planet = Planet({
      name: name
    });
    planets.push(_planet);
    _mint(msg.sender, planetId);
    tokenToPriceMap[planetId] = PRICE;
  }

  function getCurrentPrice(uint256 planetId) public view onlyMintedTokens(planetId) returns(uint256) {
    uint256 lastPrice = tokenToPriceMap[planetId];
    uint256 askingPrice = (lastPrice * 50) / 100;
    return askingPrice;
  }

  modifier onlyMintedTokens(uint256 planetId) {
    require(tokenToPriceMap[planetId] != 0);
    _;
  }
}
