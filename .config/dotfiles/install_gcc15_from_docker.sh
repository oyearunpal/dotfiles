#!/bin/bash
set -e

# Settings
INSTALL_DIR="/opt/gcc-15"
WRAPPER_DIR="/usr/local/bin"
CONTAINER_NAME="gcc15-temp"
GCC_VERSION="15.1.0"
GCC_IMAGE="gcc:15"

echo "📦 Pulling Docker image $GCC_IMAGE..."
docker pull $GCC_IMAGE

echo "🐳 Starting container $CONTAINER_NAME..."
docker run --rm -d --name $CONTAINER_NAME $GCC_IMAGE sleep infinity

echo "📁 Creating destination: $INSTALL_DIR"
sudo mkdir -p "$INSTALL_DIR"

echo "📋 Copying essential GCC files..."

# Binaries
docker cp $CONTAINER_NAME:/usr/local/bin "$INSTALL_DIR/"

# GCC internals (cc1, cc1plus, collect2, liblto_plugin)
docker cp $CONTAINER_NAME:/usr/local/libexec "$INSTALL_DIR/"

# C++ headers
docker cp $CONTAINER_NAME:/usr/local/include/c++ "$INSTALL_DIR/include/"

# Glibc headers (not needed, using system glibc)

# Libstdc++, OpenMP, runtime libs
docker cp $CONTAINER_NAME:/usr/local/lib64 "$INSTALL_DIR/"

# GCC-specific libraries
docker cp $CONTAINER_NAME:/usr/lib/gcc "$INSTALL_DIR/lib/gcc"

# Additional generic libs (e.g., libgcc_s)
docker cp $CONTAINER_NAME:/usr/lib/x86_64-linux-gnu "$INSTALL_DIR/lib/x86_64-linux-gnu"

echo "🔧 Creating wrapper scripts..."

# g++-15 wrapper
sudo tee "$WRAPPER_DIR/g++-15" > /dev/null <<EOF
#!/bin/bash
export PATH="$INSTALL_DIR/bin:\$PATH"
export COMPILER_PATH="$INSTALL_DIR/libexec/gcc/x86_64-linux-gnu/$GCC_VERSION:$INSTALL_DIR/bin"
export LIBRARY_PATH="$INSTALL_DIR/lib64:$INSTALL_DIR/lib/x86_64-linux-gnu"
export CPLUS_INCLUDE_PATH="$INSTALL_DIR/include/c++/$GCC_VERSION"
exec "$INSTALL_DIR/bin/g++" "\$@"
EOF

# gcc-15 wrapper
sudo tee "$WRAPPER_DIR/gcc-15" > /dev/null <<EOF
#!/bin/bash
export PATH="$INSTALL_DIR/bin:\$PATH"
export COMPILER_PATH="$INSTALL_DIR/libexec/gcc/x86_64-linux-gnu/$GCC_VERSION:$INSTALL_DIR/bin"
export LIBRARY_PATH="$INSTALL_DIR/lib64:$INSTALL_DIR/lib/x86_64-linux-gnu"
export C_INCLUDE_PATH="$INSTALL_DIR/include/c++/$GCC_VERSION"
exec "$INSTALL_DIR/bin/gcc" "\$@"
EOF

sudo chmod +x "$WRAPPER_DIR/gcc-15" "$WRAPPER_DIR/g++-15"

echo "🧹 Cleaning up container..."
docker stop $CONTAINER_NAME

echo "✅ Testing g++-15 with a sample program..."
echo '#include <iostream>
int main() { std::cout << "✅ GCC 15 installed and working!" << std::endl; return 0; }' > /tmp/test_gcc15.cpp

g++-15 /tmp/test_gcc15.cpp -o /tmp/test_gcc15
/tmp/test_gcc15

echo "🎉 Success: GCC 15 is available as gcc-15 and g++-15"

