#!/bin/bash

# Build
rm cart.nes
./tools/asm6 src/cart.asm cart.nes

# Push
rm -r release
mkdir release
cp cart.nes release/cart.nes
cp README.txt release/README.txt
~/Applications/butler push ~/Repositories/Hundredrabbits/Donsol/release hundredrabbits/donsol:nes
~/Applications/butler status hundredrabbits/donsol
rm -r release