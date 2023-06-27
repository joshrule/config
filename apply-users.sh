#!/bin/sh
pushd ~/project/config
home-manager switch --flake .#rule
popd
