#!/usr/bin/env bash

set -euo pipefail
if [[ -f lib.sh ]]; then
    source lib.sh
fi

function install-font() {
    (
        cd $(dirname $0)
        local FONT_SOURCE_DIR=../fonts
        local FONT_DEST_DIR=~/.local/share/fonts
        font=$1
        family=$2
        mkdir -p "${FONT_DEST_DIR}/${family}"
        if [[ -f "${FONT_SOURCE_DIR}/${font}" ]]; then
            cp "${FONT_SOURCE_DIR}/${font}" ~/.local/share/fonts/${family}/${font}
        else
            echo "${font} not found"
        fi
    )
}

install-font SourceCodePro-BlackIt.otf source-code-pro
install-font SourceCodePro-Black.otf source-code-pro
install-font SourceCodePro-BoldIt.otf source-code-pro
install-font SourceCodePro-Bold.otf source-code-pro
install-font SourceCodePro-ExtraLightIt.otf source-code-pro
install-font SourceCodePro-ExtraLight.otf source-code-pro
install-font SourceCodePro-It.otf source-code-pro
install-font SourceCodePro-LightIt.otf source-code-pro
install-font SourceCodePro-Light.otf source-code-pro
install-font SourceCodePro-MediumIt.otf source-code-pro
install-font SourceCodePro-Medium.otf source-code-pro
install-font SourceCodePro-Regular.otf source-code-pro
install-font SourceCodePro-SemiboldIt.otf source-code-pro
install-font SourceCodePro-Semibold.otf source-code-pro

fc-cache -f -v
(
    cd $(dirname $0)
    ./install-hack.sh v3.003
)
