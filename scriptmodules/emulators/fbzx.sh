#!/usr/bin/env bash

# This file is part of the ArchyPie project.
#
# Please see the LICENSE file at the top-level directory of this distribution.

rp_module_id="fbzx"
rp_module_desc="FBZX - ZX Spectrum Emulator"
rp_module_help="ROM Extensions: .sna .szx .z80 .tap .tzx .gz .udi .mgt .img .trd .scl .dsk .zip\n\nCopy your ZX Spectrum to $romdir/zxspectrum"
rp_module_licence="GPL3 https://gitlab.com/rastersoft/fbzx/-/raw/master/COPYING"
rp_module_repo="git https://gitlab.com/rastersoft/fbzx.git :_get_branch_fbzx"
rp_module_section="opt"
rp_module_flags="!mali !kms"

function _get_branch_fbzx() {
    local branch
    # use older version for non x86 systems (faster)
    if ! isPlatform "x86"; then
        branch="2.11.1"
    else
        branch=$(download https://gitlab.com/api/v4/projects/rastersoft%2Ffbzx/releases - | grep -m 1 tag_name | cut -d\" -f4)
    fi
    echo "$branch"
}

function depends_fbzx() {
    getDepends ffmpeg sdl
}

function sources_fbzx() {
    gitPullOrClone
    ! isPlatform "x86" && sed -i 's|PREFIX2=$(PREFIX)/usr|PREFIX2=$(PREFIX)|' Makefile
}

function build_fbzx() {
    make clean
    make
    if ! isPlatform "x86"; then
        md_ret_require="$md_build/fbzx"
    else
        md_ret_require="$md_build/src/fbzx"
    fi
}

function install_fbzx() {
    if ! isPlatform "x86"; then
        mkdir "$md_inst/bin"
    fi
    make install PREFIX="$md_inst"
}

function configure_fbzx() {
    mkRomDir "zxspectrum"

    addEmulator 0 "$md_id" "zxspectrum" "pushd $md_inst/share; $md_inst/bin/fbzx -fs %ROM%; popd"
    addSystem "zxspectrum"
}
