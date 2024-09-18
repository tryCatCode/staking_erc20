// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Staking {
    IERC20 public token;
    mapping(address => uint256) public stakingBalance;
    mapping(address => uint256) public rewardBalance;
    uint256 public minRewardRate = 2;  // 2% mínimo
    uint256 public maxRewardRate = 10; // 10% máximo
    uint256 public rewardRate; // Tasa de recompensa variable

    constructor(IERC20 _token) {
        token = _token;
    }

    function stake(uint256 _amount) public {
        require(_amount > 0, "El monto debe ser mayor que cero");
        token.transferFrom(msg.sender, address(this), _amount);
        stakingBalance[msg.sender] += _amount;
        // Añadir lógica para calcular recompensas basadas en el staking inicial
    }

    function withdraw(uint256 _amount) public {
        require(stakingBalance[msg.sender] >= _amount, "Saldo insuficiente");
        stakingBalance[msg.sender] -= _amount;
        token.transfer(msg.sender, _amount);
        // Distribuir recompensas antes de realizar el retiro
        claimRewards();
    }

    function claimRewards() public {
        uint256 reward = calculateRewards(msg.sender);
        rewardBalance[msg.sender] = 0; // Reiniciar el saldo de recompensas
        token.transfer(msg.sender, reward); // Pagar las recompensas
    }

    function calculateRewards(address _user) internal view returns (uint256) {
        // Lógica para generar una tasa de recompensa aleatoria entre 2% y 10%
        uint256 randomRewardRate = getRandomRewardRate(minRewardRate, maxRewardRate);
        
        // Cálculo de la recompensa en base al saldo de staking y la tasa de recompensa
        return (stakingBalance[_user] * randomRewardRate) / 100;
    }

    // Función que genera una tasa aleatoria entre min y max
    function getRandomRewardRate(uint256 _min, uint256 _max) internal view returns (uint256) {
        // Esto usa la dificultad del bloque y la dirección del usuario como una semilla simple
        return (_min + uint256(keccak256(abi.encodePacked(block.prevrandao, block.timestamp, msg.sender))) % (_max - _min + 1));
    }
}
