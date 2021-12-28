// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC165.sol";
import "./interfaces/IERC721.sol";

contract ERC721 is ERC165, IERC721 {
    // mapping of token id with token address
    mapping(uint256 => address) private _tokenOwner;
    // mapping of token owner and how many token then owned
    mapping(address => uint256) private _ownedTokensCount;

    constructor() {
        _registerInterfaces(
            bytes4(
                keccak256("balanceOf(bytes4)") ^
                    keccak256("ownerOf(bytes4)") ^
                    keccak256("transferFrom(bytes4)")
            )
        );
    }

    function balanceOf(address _owner) public view returns (uint256) {
        require(
            _owner != address(0),
            "ERC721: Owner query for non-existent token"
        );

        return _ownedTokensCount[_owner];
    }

    function ownerOf(uint256 _tokenId) public view returns (address) {
        address owner = _tokenOwner[_tokenId];
        require(
            owner != address(0),
            "ERC721: Owner query for non-existent token"
        );

        return owner;
    }

    /*
        FUNCTION: this return if a token id is minted before
    */
    function _exist(uint256 tokenId) internal view returns (bool) {
        address owner = _tokenOwner[tokenId];

        return owner != address(0);
    }

    function _mint(address to, uint256 tokenId) internal virtual {
        // require if creator address is not zero
        require(to != address(0), "ERC721: Token is minting to zero address");
        // require if token is already created or not
        require(!_exist(tokenId), "ERC721: Token already minted");

        _tokenOwner[tokenId] = to;
        _ownedTokensCount[to] += 1;

        emit Transfer(address(0), to, tokenId);
    }

    function _transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) internal {
        require(
            _to != address(0),
            "Error - ERC721 Transfer to the zero address"
        );
        require(
            ownerOf(_tokenId) == _from,
            "Error - ERC721 Trying to transfer token the address doesn't own!"
        );

        _tokenOwner[_tokenId] = _to;
        _ownedTokensCount[_from] -= 1;
        _ownedTokensCount[_to] += 1;

        emit Transfer(_from, _to, _tokenId);
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) public {
        _transferFrom(_from, _to, _tokenId);
    }
}
