HELP_TEXT="Go Manager
A minimalist approach to managing multiple Go installations. Inspired by chruby and ruby-install.

Usage: go-manager <command> [<flags>] [<arguments>]

Commands:
  install latest          - install the latest available version
  install <version>       - install a specific version

  list installed          - list all Go versions installed on your computer
  list available          - list all Go versions available for download
  list                    - same as 'go-manager list installed'

  use <version>           - use a specific version for this terminal session
  use --default <version> - always use a specific version by default

  uninstall               - uninstall the Go version you're currently using
  uninstall <version>     - uninstall a specific version

Visit https://github.com/ocrampete16/go-manager#readme for more details.
"

function _go_manager_install()
{
  echo "Installing..."
}

function _go_manager_list()
{
  echo "Listing..."
}

function _go_manager_use()
{
  if [[ $1 == "--default" ]]; then
    echo $2 > $HOME/.go-version
    export GOROOT=$HOME/.go-manager/gos/$2
    export PATH=$PATH:$GOROOT/bin
    export GOPATH=$HOME/.go-manager/workspaces/$2
  else
    export GOROOT=$HOME/.go-manager/gos/$1
    export PATH=$PATH:$GOROOT/bin
    export GOPATH=$HOME/.go-manager/workspaces/$1
  fi
}

function _go_manager_uninstall()
{
  rm -rf $HOME/.go-manager/gos/$1
}

function go-manager()
{
  case $1 in
    "install")
      _go_manager_install $2
      ;;
    "list")
      _go_manager_list $2
      ;;
    "use")
      _go_manager_use $2 $3
      ;;
    "uninstall")
      _go_manager_uninstall $2
      ;;
    *)
      echo $HELP_TEXT
      ;;
  esac
}
