#!/usr/bin/env bash

#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/typst-community/tytanic"
TOOL_NAME="tytanic"
TOOL_TEST="tt --version"

fail() {
    echo -e "asdf-$TOOL_NAME: $*"
    exit 1
}

curl_opts=(-fsSL)

# NOTE: You might want to remove this if tytanic is not hosted on GitHub releases.
if [ -n "${GITHUB_API_TOKEN:-}" ]; then
    curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
    sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
        LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
    git ls-remote --tags --refs "$GH_REPO" |
        grep -o 'refs/tags/.*' | cut -d/ -f3- |
        sed 's/^v//' # NOTE: You might want to adapt this sed to remove non-version strings from tags
}

list_all_versions() {
    list_github_tags
}

download_release() {
    local version filename url
    version="$1"
    filename="$2"

    platform=$(uname -s | tr '[:upper:]' '[:lower:]')
    arch=$(uname -m)
    case $platform in
    "darwin")
        case $arch in
        "aarch64" | "arm64")
            url="$GH_REPO/releases/download/v${version}/${TOOL_NAME}-aarch64-apple-darwin.tar.xz"
            ;;
        "x86_64")
            url="$GH_REPO/releases/download/v${version}/${TOOL_NAME}-x86_64-apple-darwin.tar.xz"
            ;;
        esac
        ;;
    "linux")
        case $arch in
        "armv7" | "armv7l")
            url="$GH_REPO/releases/download/v${version}/${TOOL_NAME}-armv7-unknown-linux-musleabi.tar.xz"
            ;;
        "aarch64" | "arm64")
            url="$GH_REPO/releases/download/v${version}/${TOOL_NAME}-aarch64-unknown-linux-musl.tar.xz"
            ;;
        "riscv64")
            url="$GH_REPO/releases/download/v${version}/${TOOL_NAME}-riscv64gc-unknown-linux-gnu.tar.xz"
            ;;
        "x86_64")
            url="$GH_REPO/releases/download/v${version}/${TOOL_NAME}-x86_64-unknown-linux-musl.tar.xz"
            ;;
        esac
        ;;
    *mingw* | *msys* | *cygwin* | *windows*)
        case $arch in
        "aarch64" | "arm64")
            url="$GH_REPO/releases/download/v${version}/${TOOL_NAME}-aarch64-pc-windows-msvc.zip"
            ;;
        "x86_64")
            url="$GH_REPO/releases/download/v${version}/${TOOL_NAME}-x86_64-pc-windows-msvc.zip"
            ;;
        esac
        ;;
    esac

    echo "* Downloading $TOOL_NAME release $version..."
    echo "  -> url: $url"
    echo "  -> target file: $filename"
    curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
    local install_type="$1"
    local version="$2"
    local install_path="${3%/bin}/bin"

    if [ "$install_type" != "version" ]; then
        fail "asdf-$TOOL_NAME supports release installs only"
    fi

    (
        mkdir -p "$install_path"
        cp -r "$ASDF_DOWNLOAD_PATH/"* "$install_path/"

        local tool_cmd
        tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
        test -x "$install_path/$tool_cmd" || fail "Expected $install_path/$tool_cmd to be executable."

        echo "$TOOL_NAME $version installation was successful!"
    ) || (
        # rm -rf "$install_path"
        fail "An error occurred while installing $TOOL_NAME $version."
    )
}
