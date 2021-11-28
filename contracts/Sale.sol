// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "./MySimpleToken.sol";

interface HomeInterface {
    function getStudentList() external view returns (string[] memory students);
}

contract Sale is MySimpleToken {
    AggregatorV3Interface internal priceFeed;
    address public home_contract = 0x0E822C71e628b20a35F8bCAbe8c11F274246e64D;

    /**
     * Aggregator: ETH/USD in Rinkeby Testnet
     */
    constructor()
        public
        MySimpleToken("MySimpleToken", "MST", 100000000000000000)
    {
        priceFeed = AggregatorV3Interface(
            0x8A753747A1Fa494EC906cE90E9f37563A8AF630e
        );
    }

    function buyTokens() public payable {
        uint256 registeredStudentsLength = getRegisteredStudentsLength();
        require(registeredStudentsLength > 0);

        uint256 amount = (msg.value * getPrice()) / registeredStudentsLength;

        if (balanceOf(address(this)) < amount) {
            msg.sender.call{gas: 3000000, value: msg.value}(
                "Sorry,there is not enough tokens"
            );
            return;
        }
        _transfer(address(this), msg.sender, amount);
    }

    function getPrice() public view returns (uint256) {
        (
            uint80 roundID,
            int256 price,
            uint256 startedAt,
            uint256 timeStamp,
            uint80 answeredInRound
        ) = priceFeed.latestRoundData();
        return uint256(price / 1e8);
    }

    function getRegisteredStudentsLength() public view returns (uint256) {
        string[] memory students = HomeInterface(home_contract)
            .getStudentList();

        return students.length;
    }
}
