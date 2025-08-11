#!/usr/bin/env bash

set -euo pipefail
# set -x
if [[ -f lib.sh ]]; then
    source lib.sh
fi

function install-font() {
    (
        cd $(dirname $0)
        local FONT_SOURCE_DIR=../fonts
        local FONT_DEST_DIR=~/.local/share/fonts
        if [[ ! -d $FONT_DEST_DIR ]]; then
            mkdir -p $FONT_DEST_DIR
        fi
        font=$1
        family=$2
        mkdir -p "${FONT_DEST_DIR}/${family}"
	    font_name=$(basename $font)
        if [[ -f "${FONT_SOURCE_DIR}/${font_name}" ]]; then
            cp "${FONT_SOURCE_DIR}/${font_name}" ~/.local/share/fonts/${family}/${font_name}
        else
            echo "${font} not found"
        fi
    )
}

FONT_SOURCE_DIR=$(dirname $0)/../fonts

# Source Code Pro fonts
install-font SourceCodePro-BlackItalic.ttf source-code-pro
install-font SourceCodePro-Black.ttf source-code-pro
install-font SourceCodePro-BoldItalic.ttf source-code-pro
install-font SourceCodePro-Bold.ttf source-code-pro
install-font SourceCodePro-ExtraLightItalic.ttf source-code-pro
install-font SourceCodePro-ExtraLight.ttf source-code-pro
install-font SourceCodePro-Italic.ttf source-code-pro
install-font SourceCodePro-LightItalic.ttf source-code-pro
install-font SourceCodePro-Light.ttf source-code-pro
install-font SourceCodePro-MediumItalic.ttf source-code-pro
install-font SourceCodePro-Medium.ttf source-code-pro
install-font SourceCodePro-Regular.ttf source-code-pro
install-font SourceCodePro-SemiBoldItalic.ttf source-code-pro
install-font SourceCodePro-SemiBold.ttf source-code-pro
install-font SourceCodePro-ExtraBoldItalic.ttf source-code-pro
install-font SourceCodePro-ExtraBold.ttf source-code-pro

# Intel One Mono fonts
install-font intelone-mono-font-family-italic.otf intelone-mono
install-font intelone-mono-font-family-medium.otf intelone-mono
install-font intelone-mono-font-family-mediumitalic.otf intelone-mono
install-font intelone-mono-font-family-regular.otf intelone-mono
install-font intelone-mono-font-family-bold.otf intelone-mono
install-font intelone-mono-font-family-bolditalic.otf intelone-mono
install-font intelone-mono-font-family-light.otf intelone-mono
install-font intelone-mono-font-family-lightitalic.otf intelone-mono

# Go fonts
install-font Go-Bold-Italic.ttf go-fonts
install-font Go-Bold.ttf go-fonts
install-font Go-Italic.ttf go-fonts
install-font Go-Medium-Italic.ttf go-fonts
install-font Go-Medium.ttf go-fonts
install-font Go-Mono-Bold-Italic.ttf go-fonts
install-font Go-Mono-Bold.ttf go-fonts
install-font Go-Mono-Italic.ttf go-fonts
install-font Go-Mono.ttf go-fonts
install-font Go-Regular.ttf go-fonts
install-font Go-Smallcaps-Italic.ttf go-fonts
install-font Go-Smallcaps.ttf go-fonts

# Departure Mono fonts
install-font DepartureMono-Regular.otf departure-mono
install-font DepartureMono-Regular.woff departure-mono
install-font DepartureMono-Regular.woff2 departure-mono


fc-cache -f -v

# Install Hack font
if [[ -f "$(dirname $0)/vendor/install-hack.sh" ]]; then
    (
        cd $(dirname $0)/vendor
        ./install-hack.sh "latest"
    )
else
    echo "Warning: install-hack.sh not found, skipping Hack font installation"
fi
