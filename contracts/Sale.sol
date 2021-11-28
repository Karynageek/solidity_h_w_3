// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

interface HomeInterface {
    function getStudentList() external view returns (string[] memory students);
}

interface ERC20Token {
    function balanceOf(address owner) external view returns (uint256 balance);

    function transfer(address recipient, uint256 value)
        external
        returns (bool success);
}

contract Sale {
    AggregatorV3Interface internal priceFeed;
    address public home_contract = 0x0E822C71e628b20a35F8bCAbe8c11F274246e64D;
    address token = 0x489D9b6fF7A2BA6AfC5eae5794038D38C7eC55C3;
    address aggregator = 0x8A753747A1Fa494EC906cE90E9f37563A8AF630e;

    /**
     * Aggregator: ETH/USD in Rinkeby Testnet
     */
    constructor() {
        priceFeed = AggregatorV3Interface(aggregator);
    }

    function buyTokens() public payable {
        uint256 registeredStudentsLength = getRegisteredStudentsLength();
        require(registeredStudentsLength > 0);

        uint256 amount = (msg.value * getPrice()) / registeredStudentsLength;

        if (ERC20Token(token).balanceOf(address(this)) >= amount) {
            ERC20Token(token).transfer(msg.sender, amount);
        } else {
            msg.sender.call{gas: 3000000, value: msg.value}(
                "Sorry, there is not enough tokens to buy"
            );
        }
    }

    function getPrice() public view returns (uint256) {
        (, int256 price, , , ) = priceFeed.latestRoundData();
        return uint256(price / 1e8);
    }

    function getRegisteredStudentsLength() public view returns (uint256) {
        string[] memory students = HomeInterface(home_contract)
            .getStudentList();

        return students.length;
    }
}
