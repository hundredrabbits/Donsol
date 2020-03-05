#!/bin/bash

# Remove old

rm cart.nes

# Lint

node lint6502

# Build

./asm6 src/cart.asm cart.nes

# Run

# fceux cart.nes
nestopia cart.nes