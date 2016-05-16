# Go Manager
A minimalist approach to managing multiple Go installations. Inspired by [chruby](https://github.com/postmodern/chruby) and [ruby-install](https://github.com/postmodern/ruby-install).

## What it does
- Lets you easily install, uninstall and switch between different versions of Go.
- Sets the necessary environment variables to start using the Go toolchain.

## What it doesn't do
Everything else.

There are no new concepts to learn. No pkgsets, environments, none of that.

## Installation
```
git clone https://github.com/ocrampete16/go-manager.git ~/.go-manager
echo "source ~/.go-manager/go-manager.sh" >> ~/.bashrc
```
If you use zsh, you'd run `echo "source ~/.go-manager/go-manager.sh" >> ~/.zshrc` instead.

## Usage
All commands follow a certain scheme: `go-manager <command> [<flags>] [<arguments>]`

### Installing Go
```
# installs the latest available version
go-manager install

# installs version 1.6.2
go-manager install 1.6.2
```

### Listing Go installations
```
# lists all Go versions installed on your computer
go-manager list installed

# lists all Go versions available for download
go-manager list available

# the same as running `go-manager list installed`
go-manager list
```

### Using Go
```
# use version 1.6.2 for this terminal session
go-manager use 1.6.2

# always use version 1.6.2 by default
go-manager use --default 1.6.2
```

### Uninstalling Go
```
# uninstalls the version of Go you're currently using
go-manager uninstall

# uninstalls version 1.6.2
go-manager uninstall 1.6.2
```
