// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts@4.7.3/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.7.3/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts@4.7.3/utils/Counters.sol";

contract Netflix is ERC721, ERC721Burnable {
    using Counters for Counters.Counter;


    struct SubscribeData{
        uint256 tokenId;
        uint256 expiry;
    }

    mapping(address => SubscribeData)  public addressToSubscrbe;
    mapping(address => bool) public isSubscribed;
    

    Counters.Counter private _tokenIdCounter;

    constructor() ERC721("Netflix", "NTF") {}


    function subscribe(address to) public returns(bool) {
        require(to != address(0), "No address found");
        require(isSubscribed[to] == false, "Already have a subscribtion");
        uint256 tokenId = _tokenIdCounter.current();
        addressToSubscrbe[to] = SubscribeData(
            tokenId,
            block.timestamp + 60*60*24*30
        );
        isSubscribed[to] = true;
        _tokenIdCounter.increment();
        _safeMint( to,tokenId);  
        return true;
    }

    function checkExpeiry(address _userAddress)public returns(bool){
        require(_userAddress != address(0),"No address found");
        require(isSubscribed[_userAddress] ,"No subscrbtion found");
        if(block.timestamp > addressToSubscrbe[_userAddress].expiry){
            _burn(addressToSubscrbe[_userAddress].tokenId);
           isSubscribed[_userAddress] = false;
            return true;
        }
        return false;
    }
    


}