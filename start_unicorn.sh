#!/bin/sh

unicorn -c config/unicorn.rb -E production -D
cat /tmp/unicorn.pid