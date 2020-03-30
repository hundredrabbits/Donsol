#!/bin/bash

# Remove old

rm cart.nes

# Lint

node ./tools/lint6502

# Build

./tools/asm6 src/cart.asm cart.nes

# Run

fceux cart.nes
# nestopia cart.nes