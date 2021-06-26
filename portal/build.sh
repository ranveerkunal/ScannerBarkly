#!/bin/bash

flutter build web --release
cp ../py/collage/qr.jpg assets/data/
cp -rf ../py/qr assets/data/
cp ../py/config.json assets/data/
cp ../README.md assets/data/
cp -rf assets/data/* ../docs/assets/data/
cp -rf build/web/* ../docs
