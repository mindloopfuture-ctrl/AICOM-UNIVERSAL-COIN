// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title AICOMRegistrar v3.1
 * @notice Permite registrar, renovar y transferir dominios .aicom
 * @author R-M-P ⚡ AICOM Protocol
 */
interface IAICOMRegistry {
    function updateRecord(string calldata domain, string calldata cid, address owner) external;
    function getOwner(string calldata domain) external view returns (address);
}

contract AICOMRegistrar {
    IAICOMRegistry public registry;
    address public admin;
    uint256 public registrationFee = 0.01 ether;

    event DomainRegistered(string domain, address indexed owner, uint256 timestamp);
    event DomainTransferred(string domain, address indexed from, address indexed to);

    constructor(address _registry) {
        registry = IAICOMRegistry(_registry);
        admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Solo admin");
        _;
    }

    function setFee(uint256 newFee) external onlyAdmin {
        registrationFee = newFee;
    }

    function register(string calldata domain, string calldata cid) external payable {
        require(msg.value >= registrationFee, "Pago insuficiente");
        require(registry.getOwner(domain) == address(0), "Dominio ya existe");
        registry.updateRecord(domain, cid, msg.sender);
        emit DomainRegistered(domain, msg.sender, block.timestamp);
    }

    function transfer(string calldata domain, address newOwner) external {
        require(registry.getOwner(domain) == msg.sender, "No eres el propietario");
        registry.updateRecord(domain, "", newOwner);
        emit DomainTransferred(domain, msg.sender, newOwner);
    }

    function withdraw() external onlyAdmin {
        payable(admin).transfer(address(this).balance);
    }
}
