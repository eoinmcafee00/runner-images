#!/bin/bash -e -o pipefail
source ~/utils/utils.sh

# Set env variable for vcpkg
VCPKG_INSTALLATION_ROOT=/usr/local/share/vcpkg
echo "export VCPKG_INSTALLATION_ROOT=${VCPKG_INSTALLATION_ROOT}" | tee -a ~/.bashrc

# workaround https://github.com/microsoft/vcpkg/issues/27786
mkdir -p ~/.vcpkg
touch ~/.vcpkg/vcpkg.path.txt

# Install vcpkg
sudo git clone https://github.com/Microsoft/vcpkg $VCPKG_INSTALLATION_ROOT
sudo $VCPKG_INSTALLATION_ROOT/bootstrap-vcpkg.sh
sudo $VCPKG_INSTALLATION_ROOT/vcpkg integrate install
sudo chmod -R 0777 $VCPKG_INSTALLATION_ROOT
sudo ln -sf $VCPKG_INSTALLATION_ROOT/vcpkg /usr/local/bin

rm -rf ~/.vcpkg

invoke_tests "Common" "vcpkg"
