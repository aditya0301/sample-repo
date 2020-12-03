# Use the official image as a parent image.
FROM node:current-slim

# Set the working directory.
WORKDIR /usr/src/app

# Add metadata to the image to describe which port the container is listening on at runtime.
EXPOSE 8080
