#!/bin/sh

if [ $1 = "p" ]; then
unicorn -c config/unicorn.rb -E production -D
elif [ $1 = "d" ]; then
unicorn -c config/unicorn.rb -E development -D
fi
cat /tmp/unicorn.pid