GO_MANAGER_DIR="$(cd "$(dirname $0)" && pwd)"
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

install_go_version() {
  local version="$1"
  if [[ "$version" == "latest" ]]; then
    version="$(
      git ls-remote --tags https://go.googlesource.com/go \
        | awk -F '/' '{ print $NF }' \
        | grep --invert-match --regexp='beta' --regexp='rc' --regexp='release' --regexp='weekly' \
        | awk -F 'o' '{ print $NF }' \
        | tail --lines=1
    )"
  fi

  local installation_dir=$GO_MANAGER_DIR/gos/$version

  if [[ "$(uname)" == "Darwin" ]]; then
    local operating_system="darwin"
    local file_extension="pkg"
  elif [[ "$(uname)" == "Linux" ]]; then
    local operating_system="linux"
    local file_extension="tar.gz"
  fi

  if [[ "$(uname -m)" == "x86_64" ]]; then
    local bit_architecture="amd64"
  elif [[ "$(uname -m)" == "i386" ]]; then
    local bit_architecture="386"
  fi

  local archive_url="https://storage.googleapis.com/golang/go$version.$operating_system-$bit_architecture.$file_extension"

  mkdir $installation_dir
  wget --output-document=- $archive_url \
    | tar --gzip --extract --file=- --directory=$installation_dir --strip-components=1
}

list_available_go_versions() {
  echo "Available Go versions:"
  git ls-remote --tags https://go.googlesource.com/go \
    | awk -F '/' '{ print $NF }' \
    | grep --invert-match --regexp='beta' --regexp='rc' --regexp='release' --regexp='weekly' \
    | awk -F 'o' '{ print $NF }' \
    | awk '{ print "  " $0 }'
}

list_installed_go_versions() {
  echo "Installed Go versions:"
  find $GO_MANAGER_DIR/gos -mindepth 1 -maxdepth 1 -type d \
    | awk -F '/' '{ print $NF }' \
    | awk '{ print "  " $0 }'
}

use_go_version() {
  local version="$1"
  export GOROOT=$GO_MANAGER_DIR/gos/$version
  export PATH=$PATH:$GOROOT/bin
}

make_go_version_default() {
  local version="$1"
  echo $version > $HOME/.go-version
}

uninstall_go_version() {
  local version="$1"
  rm -rf $GO_MANAGER_DIR/gos/$version
  unset GOROOT
}

go-manager() {
  local command="$1"

  case $command in
    "install")
      local version="$2"
      install_go_version $version
      ;;
    "list")
      if [[ "$2" == "available" ]]; then
        list_available_go_versions
      else
        list_installed_go_versions
      fi
      ;;
    "use")
      if [[ "$2" == "--default" ]]; then
        local make_default_version=true
        local version="$3"
      else
        local make_default_version=false
        local version="$2"
      fi

      use_go_version $version

      if [[ "$make_default_version" == true ]]; then
        make-go-version-default $version
      fi
      ;;
    "uninstall")
      local version="$2"
      uninstall_go_version $version
      ;;
    *)
      echo $HELP_TEXT
      ;;
  esac
}
