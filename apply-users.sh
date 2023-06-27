#!/bin/sh
pushd ~/project/config
home-manager switch --impure --flake .#rule
popd
