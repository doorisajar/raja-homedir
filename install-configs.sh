#!/bin/bash

echo "Copying Julia config"

mkdir -p ~/.julia/config
cp configs/startup.jl ~/.julia/config/

echo "Copying nono config"

mkdir -p ~/.config/nono
cp configs/pi.json ~/.config/nono/profiles
