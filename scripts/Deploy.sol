// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.7;

import {Prometheans}    from "../contracts/Prometheans.sol";
import {Proxy}          from "../contracts/Proxy.sol";
import {GelatoResolver, IPrometheansLike } from "../contracts/GelatoResolver.sol";

import {Vm} from  "../test/utils/Interfaces.sol";

contract Deployer {

    Vm vm = Vm(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("MAINNET_KEY");
        vm.startBroadcast(vm.addr(deployerPrivateKey));

        address impl = address(new Prometheans());
        address proxy = address(new Proxy(impl));

        Prometheans fire = Prometheans(address(proxy));

        fire.initialize("Prometheans", "PROMETHEANS", 75, 21600);

        // GelatoResolver resolver = new GelatoResolver();

        vm.stopBroadcast();
    }

}
