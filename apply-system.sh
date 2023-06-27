#!/bin/sh
pushd ~/project/config
sudo nixos-rebuild switch --flake .#
popd
