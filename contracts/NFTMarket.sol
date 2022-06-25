//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol"; //prevents re entrancy attacks

contract NFTMarket is ReentrancyGuard{
    using Counters for Counters.Counter;
    Counters.Counter private _itemIds;
    Counters.Counter private _itemSold;

    address payable owner; //owner of the smart contract
    uint256 listingPrice = 0.025 ether; // price to list an nft in memesea

    constructor(){
        owner = payable(msg.sender);
    }

    struct MarketItem{
        uint itemId;
        address nftContract;
        uint256 tokenId;
        address payable seller;
        address payable owner;
        uint256 price;
        bool sold;
    }

    //to use the marketItem struct using integer id
    mapping(uint256 => MarketItem) private idMarketItem;

    // event to print messsage to console
    event MarketItemCreated(
        uint indexed itemId,
        address indexed  nftContract,
        uint256 indexed tokenId,
        address payable seller,
        address payable owner,
        uint256 price,
        bool sold
    );

    /// @notice function to get listing price
    function getListingPrice() public view returns(uint256) {
        return listingPrice;
    }

    function setListingPrice(uint _price) public returns(uint256){
        if(msg.sender == address(this)){
            listingPrice = _price;
        }
        return listingPrice;
    }

    //seller lists the owners and price by paying listing price
    /// @notice function to create market item
    function createMarketItem(address nftContract, uint256 tokenId, uint256 price) public payable nonReentrant{
        require(price > 0,"Price cannot be zero, atleast 0.25 ether");
        require(msg.value == listingPrice,"Price must be equal to listing price");

        _itemIds.increment();
         uint256 itemId = _itemIds.current();

        idMarketItem[itemId] = MarketItem(
            itemId,
            nftContract,
            tokenId,
            payable(msg.sender),
            payable(address(0)),
            price,
            false
        );

        //transfer ownership of nft to contract itself
        IERC721(nftContract).transferFrom(msg.sender,address(this),tokenId);

        //to print the transaction
        emit MarketItemCreated(itemId,nftContract,tokenId,payable(msg.sender),payable(address(0)),price,false);
    }

    /// @notice function to sale
    function createMarketSale(address nftContract, uint256 itemId) public payable nonReentrant{
        uint price = idMarketItem[itemId].price;
        uint tokenId = idMarketItem[itemId].tokenId;

        require(msg.value == price,"Please submit the asking price inorder to complete purchase");

        //pay the amount to seller
        idMarketItem[itemId].seller.transfer(msg.value);

        //transfer ownership of nft from contract to buyer
        IERC721(nftContract).safeTransferFrom(address(this),msg.sender,tokenId);

        idMarketItem[itemId].owner = payable(msg.sender);
        idMarketItem[itemId].sold = true;
        _itemSold.increment();
        payable(owner).transfer(listingPrice); //pay owner of contract the listing price
    }

    /// @notice total unsold items in market
    function fetchMarketItems() public view returns (MarketItem[] memory){
        uint itemCount = _itemIds.current(); // total no of items created ever
        uint unsoldItemCount = _itemIds.current() - _itemSold.current();
        uint currentIndex = 0;

        MarketItem[] memory items = new MarketItem[](unsoldItemCount); // unsoldItemCount is size of array

        //loop to get unsold items
        for(uint i=0; i<itemCount; i++){
            //check if owner field is empty
            if(idMarketItem[i+1].owner == address(0)){
                //yes this is not sold
                uint currentId = idMarketItem[i+1].itemId;
                MarketItem storage currentItem = idMarketItem[currentId];
                items[currentIndex] = currentItem;
                currentIndex+=1;
            }
        }
        return items;
    }

    /// @notice fetch list of NFTs owned by this user
    function fetchMyNFTs() public view returns(MarketItem[] memory){
        uint totalItemCount = _itemIds.current(); // total no of items created ever

        uint itemCount = 0;
        uint currentIndex = 0;

        for(uint i=0; i<totalItemCount; i++){
            //check if owner field is empty
            if(idMarketItem[i+1].owner == msg.sender){
                //get only the items this user bought
                itemCount+=1;
            }
        }
        MarketItem[] memory items = new MarketItem[](itemCount);

        for(uint i=0; i<totalItemCount; i++){
            //check if owner field is empty
            if(idMarketItem[i+1].owner == msg.sender){
                //get only the items this user bought
                uint currentId = idMarketItem[i+1].itemId;
                MarketItem storage currentItem = idMarketItem[currentId];
                items[currentIndex] = currentItem;
                currentIndex +=1;
            }
        }
        return items;
    }

    /// @notice fetch list of NFTs owned by this user
    function fetchItemsCreated() public view returns(MarketItem[] memory){
        uint totalItemCount = _itemIds.current(); // total no of items created ever

        uint itemCount = 0;
        uint currentIndex = 0;

        for(uint i=0; i<totalItemCount; i++){
            //check if owner field is empty
            if(idMarketItem[i+1].seller == msg.sender){
                //get only the items this user bought
                itemCount+=1;
            }
        }
        MarketItem[] memory items = new MarketItem[](itemCount);

        for(uint i=0; i<totalItemCount; i++){
            //check if owner field is empty
            if(idMarketItem[i+1].seller == msg.sender){
                //get only the items this user bought
                uint currentId = idMarketItem[i+1].itemId;
                MarketItem storage currentItem = idMarketItem[currentId];
                items[currentIndex] = currentItem;
                currentIndex +=1;
            }
        }
        return items;
    }

}