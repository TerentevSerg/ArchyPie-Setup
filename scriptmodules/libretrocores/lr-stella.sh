#!/usr/bin/env bash

# This file is part of the ArchyPie project.
#
# Please see the LICENSE file at the top-level directory of this distribution.

rp_module_id="lr-stella"
rp_module_desc="Atari 2600 Libretro Core"
rp_module_help="ROM Extensions: .a26 .bin .rom .zip .gz\n\nCopy Your Atari 2600 ROMs to $romdir/atari2600"
rp_module_licence="GPL2 https://raw.githubusercontent.com/stella-emu/stella/master/License.txt"
rp_module_repo="git https://github.com/stella-emu/stella.git master"
rp_module_section="exp"

function sources_lr-stella() {
    gitPullOrClone
}

function build_lr-stella() {
    cd src/os/libretro
    make clean
    make LTO=""
    md_ret_require="$md_build/src/os/libretro/stella_libretro.so"
}

function install_lr-stella() {
    md_ret_files=(
        'README.md'
        'src/os/libretro/stella_libretro.so'
        'License.txt'
    )
}

function configure_lr-stella() {
    mkRomDir "atari2600"
    defaultRAConfig "atari2600"

    addEmulator 0 "$md_id" "atari2600" "$md_inst/stella_libretro.so"
    addSystem "atari2600"
}
