#!/bin/bash

test -f public/index.html
test -f public/style.css
test -f public/script.js

echo "Tests passed"