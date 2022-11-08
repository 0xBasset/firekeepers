// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.7;

import {Firekeepers}    from "../contracts/Firekeepers.sol";
import {Proxy}          from "../contracts/Proxy.sol";
import {GelatoResolver, IPrometheansLike } from "../contracts/GelatoResolver.sol";

import {Vm} from  "../test/utils/Interfaces.sol";

contract Deployer {

    Vm vm = Vm(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("GOERLI_KEY");
        vm.startBroadcast(vm.addr(deployerPrivateKey));

        address impl = address(new Firekeepers());
        address proxy = address(new Proxy(impl));

        Firekeepers fire = Firekeepers(address(proxy));

        fire.initialize("Firekeepers", "FIREKEEPERS", 75, 750);

        GelatoResolver resolver = new GelatoResolver(address(fire));

        vm.stopBroadcast();
    }


}
