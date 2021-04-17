#!/bin/bash

flutter build web --release
cp -rf assets/data/* ../docs/assets/data/
cp -rf build/web/* ../docs

