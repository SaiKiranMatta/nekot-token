// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Nekot {
    string public name = "Nekot";
    string public symbol = "NKT";
    uint8 public immutable decimals;
    uint256 public totalSupply;
    
    address public owner;
    bool public paused;
    
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Paused(address account);
    event Unpaused(address account);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event TokensBurned(address indexed burner, uint256 amount);
    event TokensMinted(address indexed to, uint256 amount);
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Nekot: caller is not the owner");
        _;
    }
    
    modifier whenNotPaused() {
        require(!paused, "Nekot: token operations are paused");
        _;
    }

    modifier validAddress(address _addr) {
        require(_addr != address(0), "Nekot: zero address not allowed");
        _;
    }
    
    constructor(uint8 _decimals, uint256 initialSupply) {
        require(_decimals > 0 && _decimals <= 18, "Nekot: invalid decimals");
        require(initialSupply > 0, "Nekot: initial supply must be greater than 0");
        
        decimals = _decimals;
        owner = msg.sender;
        uint256 initialTokens = initialSupply * (10 ** uint256(decimals));
        require(initialTokens / (10 ** uint256(decimals)) == initialSupply, "Nekot: initial supply overflow");
        
        totalSupply = initialTokens;
        _balances[msg.sender] = initialTokens;
        emit Transfer(address(0), msg.sender, initialTokens);
    }
    
    function balanceOf(address account) public view validAddress(account) returns (uint256) {
        return _balances[account];
    }
    
    function transfer(address to, uint256 amount) public whenNotPaused validAddress(to) returns (bool) {
        require(amount > 0, "Nekot: transfer amount must be greater than zero");
        require(_balances[msg.sender] >= amount, "Nekot: insufficient balance");
        require(_balances[to] + amount >= _balances[to], "Nekot: transfer amount overflow");
        
        _balances[msg.sender] -= amount;
        _balances[to] += amount;
        emit Transfer(msg.sender, to, amount);
        return true;
    }
    
    function allowance(address tokenOwner, address spender) public view 
        validAddress(tokenOwner) 
        validAddress(spender) 
        returns (uint256) 
    {
        return _allowances[tokenOwner][spender];
    }
    
    function approve(address spender, uint256 amount) public whenNotPaused validAddress(spender) returns (bool) {
        _allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }
    
    function transferFrom(address from, address to, uint256 amount) public whenNotPaused 
        validAddress(from) 
        validAddress(to) 
        returns (bool) 
    {
        require(amount > 0, "Nekot: transfer amount must be greater than zero");
        require(_balances[from] >= amount, "Nekot: insufficient balance");
        require(_allowances[from][msg.sender] >= amount, "Nekot: insufficient allowance");
        require(_balances[to] + amount >= _balances[to], "Nekot: transfer amount overflow");
        
        _balances[from] -= amount;
        _balances[to] += amount;
        _allowances[from][msg.sender] -= amount;
        
        emit Transfer(from, to, amount);
        return true;
    }
    
    function increaseAllowance(address spender, uint256 addedValue) public whenNotPaused validAddress(spender) returns (bool) {
        require(_allowances[msg.sender][spender] + addedValue >= _allowances[msg.sender][spender], "Nekot: allowance overflow");
        _allowances[msg.sender][spender] += addedValue;
        emit Approval(msg.sender, spender, _allowances[msg.sender][spender]);
        return true;
    }
    
    function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotPaused validAddress(spender) returns (bool) {
        uint256 currentAllowance = _allowances[msg.sender][spender];
        require(currentAllowance >= subtractedValue, "Nekot: decreased allowance below zero");
        _allowances[msg.sender][spender] = currentAllowance - subtractedValue;
        emit Approval(msg.sender, spender, _allowances[msg.sender][spender]);
        return true;
    }
    
    function mint(address to, uint256 amount) public onlyOwner validAddress(to) returns (bool) {
        require(amount > 0, "Nekot: mint amount must be greater than zero");
        require(totalSupply + amount >= totalSupply, "Nekot: mint amount overflow");
        
        totalSupply += amount;
        _balances[to] += amount;
        emit Transfer(address(0), to, amount);
        emit TokensMinted(to, amount);
        return true;
    }
    
    function burn(uint256 amount) public whenNotPaused returns (bool) {
        require(amount > 0, "Nekot: burn amount must be greater than zero");
        require(_balances[msg.sender] >= amount, "Nekot: burn amount exceeds balance");
        
        _balances[msg.sender] -= amount;
        totalSupply -= amount;
        emit Transfer(msg.sender, address(0), amount);
        emit TokensBurned(msg.sender, amount);
        return true;
    }
    
    function pause() public onlyOwner {
        require(!paused, "Nekot: token is already paused");
        paused = true;
        emit Paused(msg.sender);
    }
    
    function unpause() public onlyOwner {
        require(paused, "Nekot: token is not paused");
        paused = false;
        emit Unpaused(msg.sender);
    }
    
    function transferOwnership(address newOwner) public onlyOwner validAddress(newOwner) {
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }
    
    function recoverERC20(address tokenAddress, uint256 tokenAmount) public onlyOwner validAddress(tokenAddress) {
        require(tokenAddress != address(this), "Nekot: cannot recover own token");
        require(tokenAmount > 0, "Nekot: recovery amount must be greater than zero");
        
        (bool success, ) = tokenAddress.call(
            abi.encodeWithSelector(0xa9059cbb, owner, tokenAmount)
        );
        require(success, "Nekot: recovery failed");
    }
}