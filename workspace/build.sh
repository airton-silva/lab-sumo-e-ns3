#!/bin/bash

echo "Building SUMO-NS3 VNC Lab Environment..."
docker build -t sumo-ns3-vnc-lab .

echo "Creating workspace directory..."
mkdir -p workspace

echo "Build completed!"
echo "To run the container:"
echo "  docker-compose up"
echo ""
echo "Or manually:"
echo "  docker run -p 6080:6080 -p 8888:8888 -v $(pwd)/workspace:/workspace sumo-ns3-vnc-lab"