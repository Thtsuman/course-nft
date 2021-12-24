// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC721.sol";

contract ERC721Enumerable is ERC721 {
    uint256[] private _allTokens;
    // maping from tokenId to position in _allTokens array
    mapping(uint256 => uint256) private _allTokenIndex;
    // mapping of owner to the list of all owner token ids
    mapping(address => uint256[]) private _ownedTokens;
    // mapping from token ID to index of the owner tokens list
    mapping(uint256 => uint256) private _ownedTokensIndex;

    /// @notice Count NFTs tracked by this contract
    /// @return A count of valid NFTs tracked by this contract, where each one of
    ///  them has an assigned and queryable owner not equal to the zero address
    function totalSupply() external view returns (uint256) {
        return _allTokens.length;
    }

    // helper function to keep track of tokenIndex
    function tokenIndex(uint256 index) public view returns (uint256) {
        require(index < this.totalSupply(), "global index is out of bound");
        return _allTokens[index];
    }

    // helper function to keep track of owner by token index
    function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
        require(index < this.balanceOf(owner), "owner index is out of bound");
        return _ownedTokens[owner][index];
    }

    function _mint(address to, uint256 tokenId) internal override(ERC721) {
        super._mint(to, tokenId);
        _addTokensToAllTokenEnumeration(tokenId);
        _addTokensToOwnerEnumeration(to, tokenId);
    }

    function _addTokensToAllTokenEnumeration(uint256 tokenId) private {
        _allTokenIndex[tokenId] = _allTokens.length;
        _allTokens.push(tokenId);
    }

    function _addTokensToOwnerEnumeration(address to, uint256 tokenId) private {
        _ownedTokens[to].push(tokenId);
        _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
    }
}
