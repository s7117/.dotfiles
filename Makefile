all:
	echo "Inspect Makefile for targets..."

# Install stuff for Arch
arch:
	./bin/arch.sh

# Install stuff for Ubuntu.
ubuntu:
	./bin/ubuntu.sh

# Install stuff for Docker Container (Ubuntu).
docker:
	./bin/docker.sh

# Install stuff for MacOS.
mac:
	./bin/mac.sh

fedora:
	./bin/fedora.sh

# Clean up install.
clean:
	echo 'Not Implemented Yet!'
