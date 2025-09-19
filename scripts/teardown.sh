#!/usr/bin/env bash
set -e

cd "$(dirname "$0")/../"

sudo containerlab destroy -t network-a.clab.yaml
sudo containerlab destroy -t network-b.clab.yaml
sudo containerlab destroy -t network-c.clab.yaml
