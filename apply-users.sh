#!/bin/sh
pushd ~/project/config
home-manager switch -f ./users/rule/home.nix
popd
