// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.0;

import { Prometheans as ERC721 } from "../../contracts/Prometheans.sol";

contract MockERC721 is ERC721 {

    function tokenURI(uint256) public pure virtual override returns (string memory) {}

    function mint(address to, uint256 tokenId) public virtual {
        _mint(to, tokenId, 1);
    }

    function burn(uint256 tokenId) public virtual {
        _burn(tokenId);
    }

    function safeMint(address to, uint256 tokenId) public virtual {
        _safeMint(to, tokenId, 1);
    }

    function safeMint(
        address to,
        uint256 tokenId,
        bytes memory data
    ) public virtual {
        _safeMint(to, tokenId, 1, data);
    }
}
