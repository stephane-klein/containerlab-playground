#!/usr/bin/env bash
set -e

cd "$(dirname "$0")/../"

sudo containerlab deploy -t network-a.clab.yaml --reconfigure
sudo containerlab deploy -t network-b.clab.yaml --reconfigure
sudo containerlab deploy -t network-c.clab.yaml --reconfigure
