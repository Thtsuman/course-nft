// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC721Connector.sol";

contract KryptoBirdz is ERC721Connector {

    string[] public kryptoBirdz;
    mapping(string => bool) public _kryptoBridzExists;
    
    constructor() ERC721Connector("KryptoBirdz", "KBIRDZ") {}

    function mint(string memory _kryptoBird) public {

        require(!_kryptoBridzExists[_kryptoBird], 'KryptoBrid: Error KryptoBrid already exist');

        kryptoBirdz.push(_kryptoBird);
        uint256 _id = kryptoBirdz.length - 1;

        _mint(msg.sender, _id);
        _kryptoBridzExists[_kryptoBird] = true;
    }
}
