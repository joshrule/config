#!/bin/sh
pushd ~/project/config
sudo nixos-rebuild switch -I nixos-config=./system/configuration.nix
popd
