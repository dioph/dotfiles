#!/bin/sh
feh --randomize --bg-fill ~/Pictures/wallpapers/*
while sleep $1
do feh --randomize --bg-fill ~/Pictures/wallpapers/*
done

