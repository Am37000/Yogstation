#!/bin/bash

#Project dependencies file
#Final authority on what's required to fully build the project

# byond version
# Extracted from the Dockerfile. Change by editing Dockerfile's FROM command.
export BYOND_MAJOR=514
export BYOND_MINOR=1575

#rust_g git tag
export RUST_G_VERSION=0.4.5

#node version
export NODE_VERSION=12
export NODE_VERSION_PRECISE=12.20.0

# PHP version
export PHP_VERSION=7.2

# SpacemanDMM git tag
export SPACEMAN_DMM_VERSION=suite-1.7

# Auxmos git tag
export AUXMOS_VERSION=434ed4ca7a0bf072f9861bd6e54552af8fb9e27f
