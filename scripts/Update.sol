// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.7;

import {Prometheans}    from "../contracts/Prometheans.sol";
import {Proxy}          from "../contracts/Proxy.sol";
import {GelatoResolver, IPrometheansLike } from "../contracts/GelatoResolver.sol";

import {Vm} from  "../test/utils/Interfaces.sol";

contract Updater {

    Vm vm = Vm(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("MAINNET_KEY");
        vm.startBroadcast(vm.addr(deployerPrivateKey));

        address impl = address(new Prometheans());

        Proxy proxy = Proxy(payable(0xc4a5025c4563Ad0ACC09d92c2506e6744DAd58Eb)); 
        proxy.setImplementation(impl);

        vm.stopBroadcast();
    }

}
