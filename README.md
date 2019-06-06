# gkubenv

Intended to make everyones lifes easier by automatically changing the `gcloud` and `kubectl` context based on a small configuration file. This can be added as a submodule together with a minimal config your existing code repository.

## Installation

### Mac OS X

1. Install direnv via brew `brew install direnv`
1. (iTerm users only) Add this line at the end of your ~/.bash_profile: `eval "$(direnv hook $SHELL)"`
1. Enjoy!

## Usage

1. Add the submodule to your existing Git project
1. Copy the sample `gkubenv.yaml` from `examples` to your root folder and change the values accordingly
