#!/usr/bin/env bash

# This file is part of the ArchyPie project.
#
# Please see the LICENSE file at the top-level directory of this distribution.

rp_module_id="dosbox-staging"
rp_module_desc="DOSBox-Staging - MS-DOS x86 Emulator"
rp_module_help="ROM Extensions: .bat .com .exe .sh .conf\n\nCopy Your DOS Games to: $romdir/pc"
rp_module_licence="GPL2 https://raw.githubusercontent.com/dosbox-staging/dosbox-staging/master/COPYING"
rp_module_repo="git https://github.com/dosbox-staging/dosbox-staging.git :_get_branch_dosbox-staging"
rp_module_section="exp"
rp_module_flags="sdl2"

function _get_branch_dosbox-staging() {
    download https://api.github.com/repos/dosbox-staging/dosbox-staging/releases/latest - | grep -m 1 tag_name | cut -d\" -f4
}

function depends_dosbox-staging() {
    local depends=(
        'alsa-lib'
        'cmake'
        'fluidsynth'
        'gzip'
        'libpng'
        'meson'
        'ncurses'
        'ninja'
        'opusfile'
        'sdl2'
        'sdl2_net'
    )
    getDepends "${depends[@]}"
}

function sources_dosbox-staging() {
    gitPullOrClone
}

function build_dosbox-staging() {
    local params=(-Dbuildtype=release -Ddefault_library=static --prefix="$md_inst")

    cd "$md_build"
    meson setup "${params[@]}" build
    ninja -C build

    md_ret_require=("$md_build/build/dosbox")
}

function install_dosbox-staging() {
    cd "$md_build/build"
    meson install
}

function configure_dosbox-staging() {
    configure_dosbox

    [[ "$md_id" == "remove" ]] && return

    local config_path=$(su "$user" -c "\"$md_inst/bin/dosbox\" -printconf")
    if [[ -f "$config_path" ]]; then
        iniConfig " = " "" "$config_path"
        if isPlatform "rpi"; then
            iniSet "fullscreen" "true"
            iniSet "fullresolution" "desktop"
            iniSet "output" "texturenb"
            iniSet "core" "dynamic"
            iniSet "cycles" "25000"
        fi
    fi
}
