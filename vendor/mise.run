#!/bin/sh
set -eu

#region logging setup
if [ "${MISE_DEBUG-}" = "true" ] || [ "${MISE_DEBUG-}" = "1" ]; then
  debug() {
    echo "$@" >&2
  }
else
  debug() {
    :
  }
fi

if [ "${MISE_QUIET-}" = "1" ] || [ "${MISE_QUIET-}" = "true" ]; then
  info() {
    :
  }
else
  info() {
    echo "$@" >&2
  }
fi

error() {
  echo "$@" >&2
  exit 1
}
#endregion

#region environment setup
get_os() {
  os="$(uname -s)"
  if [ "$os" = Darwin ]; then
    echo "macos"
  elif [ "$os" = Linux ]; then
    echo "linux"
  else
    error "unsupported OS: $os"
  fi
}

get_arch() {
  musl=""
  if type ldd >/dev/null 2>/dev/null; then
    libc=$(ldd /bin/ls | grep 'musl' | head -1 | cut -d ' ' -f1)
    if [ -n "$libc" ]; then
      musl="-musl"
    fi
  fi
  arch="$(uname -m)"
  if [ "$arch" = x86_64 ]; then
    echo "x64$musl"
  elif [ "$arch" = aarch64 ] || [ "$arch" = arm64 ]; then
    echo "arm64$musl"
  elif [ "$arch" = armv7l ]; then
    echo "armv7$musl"
  else
    error "unsupported architecture: $arch"
  fi
}

get_ext() {
  if [ -n "${MISE_INSTALL_EXT:-}" ]; then
    echo "$MISE_INSTALL_EXT"
  elif [ -n "${MISE_VERSION:-}" ] && echo "$MISE_VERSION" | grep -q '^v2024'; then
    # 2024 versions don't have zstd tarballs
    echo "tar.gz"
  elif tar_supports_zstd; then
    echo "tar.zst"
  elif command -v zstd >/dev/null 2>&1; then
    echo "tar.zst"
  else
    echo "tar.gz"
  fi
}

tar_supports_zstd() {
  # tar is bsdtar or version is >= 1.31
  if tar --version | grep -q 'bsdtar' && command -v zstd >/dev/null 2>&1; then
    true
  elif tar --version | grep -q '1\.(3[1-9]|[4-9][0-9]'; then
    true
  else
    false
  fi
}

shasum_bin() {
  if command -v shasum >/dev/null 2>&1; then
    echo "shasum"
  elif command -v sha256sum >/dev/null 2>&1; then
    echo "sha256sum"
  else
    error "mise install requires shasum or sha256sum but neither is installed. Aborting."
  fi
}

get_checksum() {
  version=$1
  os=$2
  arch=$3
  ext=$4
  url="https://github.com/jdx/mise/releases/download/v${version}/SHASUMS256.txt"

  # For current version use static checksum otherwise
  # use checksum from releases
  if [ "$version" = "v2025.8.7" ]; then
    checksum_linux_x86_64="c2d67d52880373931166343ef9a3b97665175ac2796dc95b9310179d341b2713  ./mise-v2025.8.7-linux-x64.tar.gz"
    checksum_linux_x86_64_musl="86dd3a47803f88c5335bef6fb90b19a9ce22d40978bb65a16d0da423232e6712  ./mise-v2025.8.7-linux-x64-musl.tar.gz"
    checksum_linux_arm64="d8dfa34d55762125e90b56ce8c9aaa037f7890fd00ac0c9cd8a097cc8530b126  ./mise-v2025.8.7-linux-arm64.tar.gz"
    checksum_linux_arm64_musl="c0ceea65a714ee10d91cfe84d64458b6269421beb447bda5960ec36ee53ee0a6  ./mise-v2025.8.7-linux-arm64-musl.tar.gz"
    checksum_linux_armv7="800fb1c4c4710eb77255fd505ddda35731410fec02ff22c3fba149c404b48078  ./mise-v2025.8.7-linux-armv7.tar.gz"
    checksum_linux_armv7_musl="861df356a78e752f27351edbcdfa6a084610df91295c4d97dafd1cc365c08a07  ./mise-v2025.8.7-linux-armv7-musl.tar.gz"
    checksum_macos_x86_64="2b685b3507339f07d0da97b7dcf99354a3b14a16e8767af73057711e0ddce72f  ./mise-v2025.8.7-macos-x64.tar.gz"
    checksum_macos_arm64="0b5893de7c8c274736867b7c4c7ed565b4429f4d6272521ace802f8a21422319  ./mise-v2025.8.7-macos-arm64.tar.gz"
    checksum_linux_x86_64_zstd="56be852ef23c03c30e8f1fe1984978754395ac06c19d4e7a0102c2490d82edc3  ./mise-v2025.8.7-linux-x64.tar.zst"
    checksum_linux_x86_64_musl_zstd="9e79b6771b3fe807dfca1e6e20767ff51e0c1750abfab5ae4a66a522ff905bc6  ./mise-v2025.8.7-linux-x64-musl.tar.zst"
    checksum_linux_arm64_zstd="94ede16834bd952248b605aeea4822decf3407a4a3315ddc1dab26f65fbbd1eb  ./mise-v2025.8.7-linux-arm64.tar.zst"
    checksum_linux_arm64_musl_zstd="d9e034745fc3efb2cef6ad6233f213c4396fc684b4edf7c54a2ed742cc25cf72  ./mise-v2025.8.7-linux-arm64-musl.tar.zst"
    checksum_linux_armv7_zstd="1b4779fb15fe54afe832ceaf974686bb70b51223c0dd3c51a02e89917591411a  ./mise-v2025.8.7-linux-armv7.tar.zst"
    checksum_linux_armv7_musl_zstd="5e3e1d735e2ff08052a9846b89ef37edc05c8a61b049d898c6e8e1f656851bbe  ./mise-v2025.8.7-linux-armv7-musl.tar.zst"
    checksum_macos_x86_64_zstd="b93edfaa7c95c76dce82ec1558a5dfef1c34e91c338e1be00f96fe9adc9aad1c  ./mise-v2025.8.7-macos-x64.tar.zst"
    checksum_macos_arm64_zstd="1f2688e2f9fb6cdbf07580c128eebbfbd4cdb342f0e0997ce4c39b4fa42e1253  ./mise-v2025.8.7-macos-arm64.tar.zst"

    # TODO: refactor this, it's a bit messy
    if [ "$ext" = "tar.zst" ]; then
      if [ "$os" = "linux" ]; then
        if [ "$arch" = "x64" ]; then
          echo "$checksum_linux_x86_64_zstd"
        elif [ "$arch" = "x64-musl" ]; then
          echo "$checksum_linux_x86_64_musl_zstd"
        elif [ "$arch" = "arm64" ]; then
          echo "$checksum_linux_arm64_zstd"
        elif [ "$arch" = "arm64-musl" ]; then
          echo "$checksum_linux_arm64_musl_zstd"
        elif [ "$arch" = "armv7" ]; then
          echo "$checksum_linux_armv7_zstd"
        elif [ "$arch" = "armv7-musl" ]; then
          echo "$checksum_linux_armv7_musl_zstd"
        else
          warn "no checksum for $os-$arch"
        fi
      elif [ "$os" = "macos" ]; then
        if [ "$arch" = "x64" ]; then
          echo "$checksum_macos_x86_64_zstd"
        elif [ "$arch" = "arm64" ]; then
          echo "$checksum_macos_arm64_zstd"
        else
          warn "no checksum for $os-$arch"
        fi
      else
        warn "no checksum for $os-$arch"
      fi
    else
      if [ "$os" = "linux" ]; then
        if [ "$arch" = "x64" ]; then
          echo "$checksum_linux_x86_64"
        elif [ "$arch" = "x64-musl" ]; then
          echo "$checksum_linux_x86_64_musl"
        elif [ "$arch" = "arm64" ]; then
          echo "$checksum_linux_arm64"
        elif [ "$arch" = "arm64-musl" ]; then
          echo "$checksum_linux_arm64_musl"
        elif [ "$arch" = "armv7" ]; then
          echo "$checksum_linux_armv7"
        elif [ "$arch" = "armv7-musl" ]; then
          echo "$checksum_linux_armv7_musl"
        else
          warn "no checksum for $os-$arch"
        fi
      elif [ "$os" = "macos" ]; then
        if [ "$arch" = "x64" ]; then
          echo "$checksum_macos_x86_64"
        elif [ "$arch" = "arm64" ]; then
          echo "$checksum_macos_arm64"
        else
          warn "no checksum for $os-$arch"
        fi
      else
        warn "no checksum for $os-$arch"
      fi
    fi
  else
    if command -v curl >/dev/null 2>&1; then
      debug ">" curl -fsSL "$url"
      checksums="$(curl --compressed -fsSL "$url")"
    else
      if command -v wget >/dev/null 2>&1; then
        debug ">" wget -qO - "$url"
        stderr=$(mktemp)
        checksums="$(wget -qO - "$url")"
      else
        error "mise standalone install specific version requires curl or wget but neither is installed. Aborting."
      fi
    fi
    # TODO: verify with minisign or gpg if available

    checksum="$(echo "$checksums" | grep "$os-$arch.$ext")"
    if ! echo "$checksum" | grep -Eq "^([0-9a-f]{32}|[0-9a-f]{64})"; then
      warn "no checksum for mise $version and $os-$arch"
    else
      echo "$checksum"
    fi
  fi
}

#endregion

download_file() {
  url="$1"
  filename="$(basename "$url")"
  cache_dir="$(mktemp -d)"
  file="$cache_dir/$filename"

  info "mise: installing mise..."

  if command -v curl >/dev/null 2>&1; then
    debug ">" curl -#fLo "$file" "$url"
    curl -#fLo "$file" "$url"
  else
    if command -v wget >/dev/null 2>&1; then
      debug ">" wget -qO "$file" "$url"
      stderr=$(mktemp)
      wget -O "$file" "$url" >"$stderr" 2>&1 || error "wget failed: $(cat "$stderr")"
    else
      error "mise standalone install requires curl or wget but neither is installed. Aborting."
    fi
  fi

  echo "$file"
}

install_mise() {
  version="${MISE_VERSION:-v2025.8.7}"
  version="${version#v}"
  os="${MISE_INSTALL_OS:-$(get_os)}"
  arch="${MISE_INSTALL_ARCH:-$(get_arch)}"
  ext="${MISE_INSTALL_EXT:-$(get_ext)}"
  install_path="${MISE_INSTALL_PATH:-$HOME/.local/bin/mise}"
  install_dir="$(dirname "$install_path")"
  install_from_github="${MISE_INSTALL_FROM_GITHUB:-}"
  if [ "$version" != "v2025.8.7" ] || [ "$install_from_github" = "1" ] || [ "$install_from_github" = "true" ]; then
    tarball_url="https://github.com/jdx/mise/releases/download/v${version}/mise-v${version}-${os}-${arch}.${ext}"
  elif [ -n "${MISE_TARBALL_URL-}" ]; then
    tarball_url="$MISE_TARBALL_URL"
  else
    tarball_url="https://mise.jdx.dev/v${version}/mise-v${version}-${os}-${arch}.${ext}"
  fi

  cache_file=$(download_file "$tarball_url")
  debug "mise-setup: tarball=$cache_file"

  debug "validating checksum"
  cd "$(dirname "$cache_file")" && get_checksum "$version" "$os" "$arch" "$ext" | "$(shasum_bin)" -c >/dev/null

  # extract tarball
  mkdir -p "$install_dir"
  rm -rf "$install_path"
  cd "$(mktemp -d)"
  if [ "$ext" = "tar.zst" ] && ! tar_supports_zstd; then
    zstd -d -c "$cache_file" | tar -xf -
  else
    tar -xf "$cache_file"
  fi
  mv mise/bin/mise "$install_path"
  info "mise: installed successfully to $install_path"
}

after_finish_help() {
  case "${SHELL:-}" in
  */zsh)
    info "mise: run the following to activate mise in your shell:"
    info "echo \"eval \\\"\\\$($install_path activate zsh)\\\"\" >> \"${ZDOTDIR-$HOME}/.zshrc\""
    info ""
    info "mise: run \`mise doctor\` to verify this is setup correctly"
    ;;
  */bash)
    info "mise: run the following to activate mise in your shell:"
    info "echo \"eval \\\"\\\$($install_path activate bash)\\\"\" >> ~/.bashrc"
    info ""
    info "mise: run \`mise doctor\` to verify this is setup correctly"
    ;;
  */fish)
    info "mise: run the following to activate mise in your shell:"
    info "echo \"$install_path activate fish | source\" >> ~/.config/fish/config.fish"
    info ""
    info "mise: run \`mise doctor\` to verify this is setup correctly"
    ;;
  *)
    info "mise: run \`$install_path --help\` to get started"
    ;;
  esac
}

install_mise
if [ "${MISE_INSTALL_HELP-}" != 0 ]; then
  after_finish_help
fi
