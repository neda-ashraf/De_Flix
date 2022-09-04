// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol";
import "@openzeppelin/contracts@4.7.3/utils/Counters.sol";

contract Netflix is ERC1155, ERC1155Burnable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;


     struct SubscribeData{
        uint256 tokenId;
        uint256 expeiry;
    }

    mapping(address => SubscribeData)  public addressToSubscrbe;
    mapping(uint256 => SubscribeData)  public tokenToSubscribe;
    mapping(address => bool) public isSubscribed;
    mapping(uint256 => bool) public isTokenSubscribed;
    constructor() ERC1155("") {}

    function subscribe(address account)
        public returns(bool)
    {
        require(account !=  address(0), "No address found");
        uint256 tokenId = _tokenIdCounter.current();
        tokenToSubscribe[tokenId] = SubscribeData(
            tokenId,
            block.timestamp + 60*60*24*30
        );
        isTokenSubscribed[tokenId] = true;
        _tokenIdCounter.increment();
        _mint(account, tokenId, 3, "");
        return true;
       
    }

     function checkExpeiry(uint256 _tokenId)public returns(bool){
        require(_tokenId != 0,"No token found found");
        require(isTokenSubscribed[_tokenId] ,"No subscrbtion found");
        if(block.timestamp > tokenToSubscribe[_tokenId].expeiry){
            _burn(msg.sender,_tokenId, 1);
           isTokenSubscribed[_tokenId] = false;
            return true;

        }
        return false;
    }

    

}