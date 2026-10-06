// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "../interfaces/IERC721Permit.sol";

/// @title ERC721 with permit
/// @notice Extension to ERC721 that includes a permit function for signature based approvals
abstract contract ERC721Permit is ERC721Enumerable, IERC721Permit {
    /// @dev The hash of the name used in the permit signature
    bytes32 private immutable _NAME_HASH;

    /// @dev The hash of the version string used in the permit signature
    bytes32 private immutable _VERSION_HASH;

    /// @inheritdoc IERC721Permit
    bytes32 public constant override PERMIT_TYPEHASH =
        keccak256("Permit(address spender,uint256 tokenId,uint256 nonce,uint256 deadline)");

    constructor(
        string memory name_,
        string memory symbol_,
        string memory version_
    ) ERC721(name_, symbol_) {
        _NAME_HASH = keccak256(bytes(name_));
        _VERSION_HASH = keccak256(bytes(version_));
    }

    /// @inheritdoc IERC721Permit
    function DOMAIN_SEPARATOR() public view override returns (bytes32) {
        return
            keccak256(
                abi.encode(
                    keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
                    _NAME_HASH,
                    _VERSION_HASH,
                    block.chainid,
                    address(this)
                )
            );
    }

    /// @dev Gets the current nonce for a token ID
    function _getAndIncrementNonce(uint256 tokenId) internal virtual returns (uint256);

    /// @inheritdoc IERC721Permit
    function permit(
        address spender,
        uint256 tokenId,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external payable override {
        require(block.timestamp <= deadline, "Permit expired");

        bytes32 digest =
            keccak256(
                abi.encodePacked(
                    "\x19\x01",
                    DOMAIN_SEPARATOR(),
                    keccak256(abi.encode(PERMIT_TYPEHASH, spender, tokenId, _getAndIncrementNonce(tokenId), deadline))
                )
            );
        address signer = ECDSA.recover(digest, v, r, s);
        require(signer != address(0) && signer == _ownerOf(tokenId), "Unauthorized");

        _approve(spender, tokenId, signer);
    }
}
