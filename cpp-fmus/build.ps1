# Install cmake<4 and MSVC (Windows) or GCC (Linux) build tools

git submodule init
git submodule update
New-Item -Path "build" -ItemType Directory -Force
cmake -B build .
cmake --build build --parallel

