#!/bin/bash -e -o pipefail
source ~/utils/utils.sh

brew install chruby ruby-install
brew config
ruby-install ruby -- --enable-shared
ruby-install ruby

echo "source $(brew --prefix)/opt/chruby/share/chruby/chruby.sh" >> ~/.bashrc
echo "source $(brew --prefix)/opt/chruby/share/chruby/auto.sh" >> ~/.bashrc
echo "chruby ruby-3.1.2" >> ~/.bashrc

echo Updating RubyGems...
gem update --system

gemsToInstall=$(get_toolset_value '.ruby.rubygems | .[]')
if [ -n "$gemsToInstall" ]; then
    for gem in $gemsToInstall; do
        echo "Installing gem $gem"
        gem install $gem
    done
fi

# Temporary uninstall public_suffix 5.0 gem as Cocoapods is not compatible with it yet https://github.com/actions/runner-images/issues/6149
gem uninstall public_suffix -v 5.0.0

invoke_tests "RubyGem"
