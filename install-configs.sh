#!/bin/bash

echo "Copying Julia config"

mkdir -p ~/.julia/config
cp configs/startup.jl ~/.julia/config/
