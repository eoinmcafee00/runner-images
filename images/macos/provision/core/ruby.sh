#!/bin/bash -e -o pipefail
source ~/utils/utils.sh

echo "Installing rbenv..."
brew_smart_install "rbenv"

echo "Installing ruby-build as an rbenv plugin..."
brew_smart_install "ruby-build"

echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> "$HOME/.bashrc"
echo 'eval "$(rbenv init -)"' >> "$HOME/.bashrc"
source "$HOME/.bashrc"

TOOLSET_VERSION_PATTERNS=$(get_toolset_value '.toolcache[] | select(.name | contains("Ruby")) | .versions[]')

echo "Installing Ruby versions..."
for TOOLSET_VERSION_PATTERN in ${TOOLSET_VERSION_PATTERNS[@]}; do
    LATEST_VERSION=$(rbenv install --list | grep -E "^${TOOLSET_VERSION_PATTERN}" | tail -1 | tr -d ' ')
    echo "Installing Ruby $LATEST_VERSION"

    export CFLAGS="-Wno-error=implicit-function-declaration"
    export RUBY_CONFIGURE_OPTS="--with-readline-dir=/usr/local/opt/readline/"

    if ! arch -x86_64 rbenv install $LATEST_VERSION; then
        echo "Ruby installation failed for version $LATEST_VERSION"
        echo "Printing log file:"
        cat "$(rbenv root)/build.log"
        exit 1
    fi
done


echo "Setting the default Ruby version..."
DEFAULT_RUBY_VERSION=$(get_toolset_value '.ruby.default')
rbenv global ${DEFAULT_RUBY_VERSION}

invoke_tests "Ruby"
