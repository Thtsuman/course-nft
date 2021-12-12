// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ERC721 {

    // events
    event Transfer(
        address indexed from,
        address indexed to,
        uint256 indexed tokenId
    );

    // mapping of token id with token address
    mapping(uint256 => address) private _tokenOwner;
    // mapping of token owner and how many token then owned
    mapping(address => uint256) private _ownedTokensCount;

    // FUNCTION balanceOf
    /// @notice Count all NFTs assigned to an owner
    /// @dev NFTs assigned to the zero address are considered invalid, and this
    ///  function throws for queries about the zero address.
    /// @param _owner An address for whom to query the balance
    /// @return The number of NFTs owned by `_owner`, possibly zero
    function balanceOf(address _owner) public view returns(uint256) {
        require(_owner != address(0), 'ERC721: Owner query for non-existent token');

        return _ownedTokensCount[_owner];
    }

    // FUNCTION ownerOf
    /// @notice Find the owner of an NFT
    /// @dev NFTs assigned to zero address are considered invalid, and queries
    ///  about them do throw.
    /// @param _tokenId The identifier for an NFT
    /// @return The address of the owner of the NFT
    function ownerOf(uint256 _tokenId) external view returns (address) {
        address owner = _tokenOwner[_tokenId];
        require(owner != address(0), "ERC721: Owner query for non-existent token");
        return owner;
    }


    /*
        FUNCTION: this return if a token id is minted before
    */
    function _exist(uint256 tokenId) internal view returns(bool) {
        address owner = _tokenOwner[tokenId];
        return owner != address(0);
    }

    /*
        FUNCTION: mint function will create a token in the blockchain
        * the owner of the nft will be mapped to the tokenId
        * increase the ownedTokens of a owner by 1
    */

    function _mint(address to, uint256 tokenId) internal {
        // require if creator address is not zero
        require(to != address(0), 'ERC721: Token is minting to zero address');
        // require if token is already created or not
        require(!_exist(tokenId), "ERC721: Token already minted");

        _tokenOwner[tokenId] = to;
        _ownedTokensCount[to] += 1;

        emit Transfer(address(0), to, tokenId);
    }

}