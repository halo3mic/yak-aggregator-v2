// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

library DynamicArray {

    function append(
        address[] memory _target,
        address _newElement
    ) public pure returns (address[] memory) {
        for (uint i; i < _target.length; i++) {
            if (_target[i] == address(0)) {
                 _target[i] = _newElement;
                 return _target;
            }
        }
        revert("Array is full");
    }

    function append(
        uint[] memory _target,
        uint _newElement
    ) public pure returns (uint[] memory) {
        for (uint i; i < _target.length; i++) {
            if (_target[i] == uint(0)) {
                 _target[i] = _newElement;
                 return _target;
            }
        }
        revert("Array is full");
    }

}