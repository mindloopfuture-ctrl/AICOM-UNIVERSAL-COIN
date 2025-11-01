// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title AICOM Registry v3.1
 * @notice Sistema descentralizado para registrar dominios y metadatos soberanos .aicom
 * @author R-M-P ⚡ AICOM Protocol
 */

contract AICOMRegistry {
    struct DomainRecord {
        string domain;
        string cid;
        address owner;
        uint256 timestamp;
    }

    mapping(string => DomainRecord) private registry;
    address public admin;

    event DomainRegistered(string domain, string cid, address owner, uint256 timestamp);
    event DomainUpdated(string domain, string oldCid, string newCid, uint256 timestamp);

    constructor() {
        admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Solo el administrador puede ejecutar esto");
        _;
    }

    modifier onlyOwner(string memory domain) {
        require(msg.sender == registry[domain].owner, "No eres el propietario de este dominio");
        _;
    }

    /// @notice Registra un nuevo dominio .aicom con su CID de IPFS
    function registerMetadata(string memory domain, string memory cid) public {
        require(registry[domain].owner == address(0), "Dominio ya registrado");
        registry[domain] = DomainRecord(domain, cid, msg.sender, block.timestamp);
        emit DomainRegistered(domain, cid, msg.sender, block.timestamp);
    }

    /// @notice Actualiza el CID de un dominio existente
    function updateMetadata(string memory domain, string memory newCid) public onlyOwner(domain) {
        string memory oldCid = registry[domain].cid;
        registry[domain].cid = newCid;
        registry[domain].timestamp = block.timestamp;
        emit DomainUpdated(domain, oldCid, newCid, block.timestamp);
    }

    /// @notice Consulta el CID asociado a un dominio
    function resolve(string memory domain) public view returns (string memory) {
        return registry[domain].cid;
    }

    /// @notice Transfiere propiedad del dominio a otro usuario
    function transferOwnership(string memory domain, address newOwner) public onlyOwner(domain) {
        registry[domain].owner = newOwner;
    }

    /// @notice Obtiene todos los datos del dominio
    function getRecord(string memory domain) public view returns (DomainRecord memory) {
        return registry[domain];
    }
}
