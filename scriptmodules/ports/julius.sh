#!/usr/bin/env bash

# This file is part of the ArchyPie project.
#
# Please see the LICENSE file at the top-level directory of this distribution.

rp_module_id="julius"
rp_module_desc="Julius - Caesar III Port"
rp_module_licence="AGPL https://raw.githubusercontent.com/bvschaik/julius/master/LICENSE.txt"
rp_module_repo="git https://github.com/bvschaik/julius.git :_get_branch_julius"
rp_module_section="opt"
rp_module_flags="!all 64bit"

function _get_branch_julius() {
    download https://api.github.com/repos/bvschaik/julius/releases/latest - | grep -m 1 tag_name | cut -d\" -f4
}

function depends_julius() {
    local depends=(
        'clang'
        'cmake'
        'ninja'
        'sdl2'
        'sdl2_mixer'
    )
    getDepends "${depends[@]}"
}

function sources_julius() {
    gitPullOrClone
}

function build_julius() {
    cmake . \
        -Bbuild \
        -GNinja \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX="$md_inst" \
        -DCMAKE_C_COMPILER=clang \
        -DCMAKE_BUILD_RPATH_USE_ORIGIN=ON \
        -Wno-dev
    ninja -C build clean
    ninja -C build
    md_ret_require="$md_build/build/julius"
}

function install_julius() {
    ninja -C build install/strip
}

function configure_julius() {
    mkRomDir "ports/caesar3"

    moveConfigDir "$home/.config/julius" "$md_conf_root/caesar3"

    addPort "$md_id" "caesar3" "Caesar III" "$md_inst/bin/julius $romdir/ports/caesar3"
}
