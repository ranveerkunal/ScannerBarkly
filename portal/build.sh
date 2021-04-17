#!/bin/bash

flutter build web --release
cp ../py/config.json assets/data/
cp -rf assets/data/* ../docs/assets/data/
cp -rf build/web/* ../docs

