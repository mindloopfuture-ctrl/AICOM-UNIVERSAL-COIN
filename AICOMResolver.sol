// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title AICOM Resolver v3.1
 * @notice Resolvedor para dominios .aicom — soporta address, CID/IPFS y registros de texto.
 * @author R-M-P ⚡ AICOM Protocol
 *
 * IMPORTANTE:
 *  - Este resolver NO crea dominios, solo resuelve los que ya existen en el registry.
 *  - Está pensado para trabajar junto con AICOMRegistry.sol
 */

interface IAICOMRegistry {
    function getRecord(string memory domain)
        external
        view
        returns (
            string memory,
            string memory,
            address,
            uint256
        );
}

contract AICOMResolver {
    IAICOMRegistry public registry;  // referencia al contrato de registro AICOM
    address public admin;

    // dominio → address principal
    mapping(string => address) private addrs;

    // dominio → CID/IPFS
    mapping(string => string) private contents;

    // dominio → clave → valor
    mapping(string => mapping(string => string)) private texts;

    event AddrSet(string indexed domain, address addr);
    event ContentSet(string indexed domain, string cid);
    event TextSet(string indexed domain, string indexed key, string value);
    event RegistryUpdated(address registry);

    modifier onlyAdmin() {
        require(msg.sender == admin, "AICOM: not admin");
        _;
    }

    modifier onlyDomainOwner(string memory domain) {
        (, , address owner, ) = registry.getRecord(domain);
        require(owner == msg.sender, "AICOM: not domain owner");
        _;
    }

    constructor(address _registry) {
        require(_registry != address(0), "AICOM: registry required");
        admin = msg.sender;
        registry = IAICOMRegistry(_registry);
        emit RegistryUpdated(_registry);
    }

    /// @notice Cambiar el contrato de registro (solo admin)
    function setRegistry(address _registry) external onlyAdmin {
        require(_registry != address(0), "AICOM: bad registry");
        registry = IAICOMRegistry(_registry);
        emit RegistryUpdated(_registry);
    }

    /// @notice Asigna dirección principal a un dominio .aicom
    function setAddr(string memory domain, address addr_) external onlyDomainOwner(domain) {
        addrs[domain] = addr_;
        emit AddrSet(domain, addr_);
    }

    /// @notice Asigna contenido (IPFS CID, Arweave, etc.) a un dominio .aicom
    function setContent(string memory domain, string memory cid) external onlyDomainOwner(domain) {
        contents[domain] = cid;
        emit ContentSet(domain, cid);
    }

    /// @notice Guarda un registro de texto (ej: avatar, twitter, email)
    function setText(string memory domain, string memory key, string memory value) external onlyDomainOwner(domain) {
        texts[domain][key] = value;
        emit TextSet(domain, key, value);
    }

    // ======== GETTERS =========

    function addr(string memory domain) external view returns (address) {
        return addrs[domain];
    }

    function content(string memory domain) external view returns (string memory) {
        return contents[domain];
    }

    function text(string memory domain, string memory key) external view returns (string memory) {
        return texts[domain][key];
    }
}
