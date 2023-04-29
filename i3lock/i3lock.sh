#!/bin/bash

# Define the temporary screenshot file and the blurred image file
screenshot="/tmp/screenshot-$(date +%s).png"
blurred_screenshot="/tmp/blurred-screenshot-$(date +%s).png"
resized_image="/tmp/resized-image-$(date +%s).png"

# Take a screenshot of the current screen
scrot "$screenshot"

# Use ImageMagick to apply a Gaussian blur to the screenshot
convert "$screenshot" -blur 0x8 "$blurred_screenshot"

# Resize the custom image to 75% of its original size
convert ~/.Walls/angel.png -resize 75% "$resized_image"

# Add the resized custom image in the center
composite -gravity center "$resized_image" "$blurred_screenshot" "$screenshot"

# Lock the screen using the final screenshot with the custom image and disable the password circle
i3lock -i "$screenshot"

# Clean up the temporary files
rm "$screenshot" "$blurred_screenshot" "$resized_image"

