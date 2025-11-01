// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title AICOM Universal Coin
 * @dev BEP20 / ERC20 compatible para Binance Smart Chain
 * Operador: R-M-P
 * Modo: Guardian Arcanum
 */
contract AICOMUniversalToken_BSC {
    string public name = "AICOM Universal Coin";
    string public symbol = "AICOM";
    uint8 public decimals = 18;

    uint256 public totalSupply;

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    address public owner;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    modifier onlyOwner() {
        require(msg.sender == owner, "Solo owner");
        _;
    }

    constructor() {
        owner = msg.sender;

        // 1,000,000,000 * 10^18
        uint256 initialSupply = 1_000_000_000 * (10 ** uint256(decimals));
        totalSupply = initialSupply;
        _balances[msg.sender] = initialSupply;

        emit Transfer(address(0), msg.sender, initialSupply);
    }

    // ===== ERC20/BEP20 estándar =====
    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    function transfer(address to, uint256 amount) public returns (bool) {
        _transfer(msg.sender, to, amount);
        return true;
    }

    function allowance(address tokenOwner, address spender) public view returns (uint256) {
        return _allowances[tokenOwner][spender];
    }

    function approve(address spender, uint256 amount) public returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) public returns (bool) {
        uint256 currentAllowance = _allowances[from][msg.sender];
        require(currentAllowance >= amount, "allowance insuficiente");
        unchecked {
            _approve(from, msg.sender, currentAllowance - amount);
        }
        _transfer(from, to, amount);
        return true;
    }

    // ===== Funciones internas =====
    function _transfer(address from, address to, uint256 amount) internal {
        require(from != address(0), "from = 0");
        require(to != address(0), "to = 0");
        require(_balances[from] >= amount, "balance insuficiente");

        unchecked {
            _balances[from] = _balances[from] - amount;
        }
        _balances[to] += amount;

        emit Transfer(from, to, amount);
    }

    function _approve(address tokenOwner, address spender, uint256 amount) internal {
        require(tokenOwner != address(0), "owner = 0");
        require(spender != address(0), "spender = 0");

        _allowances[tokenOwner][spender] = amount;
        emit Approval(tokenOwner, spender, amount);
    }

    // ===== Funciones del owner (opcionales) =====

    /// @notice transferir ownership si lo quieres pasar a otro address
    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "nuevo owner = 0");
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }

    /// @notice minteo opcional por si quieres crecer el supply en el futuro
    function mint(address to, uint256 amount) external onlyOwner {
        require(to != address(0), "to = 0");
        totalSupply += amount;
        _balances[to] += amount;
        emit Transfer(address(0), to, amount);
    }

    /// @notice quemar tokens que estén en tu poder
    function burn(uint256 amount) external {
        require(_balances[msg.sender] >= amount, "no hay suficientes tokens");
        _balances[msg.sender] -= amount;
        totalSupply -= amount;
        emit Transfer(msg.sender, address(0), amount);
    }
}
