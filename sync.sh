#!/bin/sh
rsync -r --exclude 'sync.sh' --exclude '.git' ./ ~
