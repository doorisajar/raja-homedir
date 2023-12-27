#!/bin/bash

echo "Copying AWS CLI and Julia configs"

cp configs/awscli ~/.aws/cli/aws

cp configs/startup.jl ~/.julia/config/
