#!/usr/bin/env bash

# This file is part of the ArchyPie project.
#
# Please see the LICENSE file at the top-level directory of this distribution.

rp_module_id="px68k"
rp_module_desc="PX68K - SHARP X68000 Emulator"
rp_module_help="You need to copy a X68000 bios file (iplrom30.dat, iplromco.dat, iplrom.dat, or iplromxv.dat), and the font file (cgrom.dat or cgrom.tmp) to $biosdir/keropi. Use F12 to access the in emulator menu."
rp_module_repo="git https://github.com/hissorii/px68k.git master"
rp_module_section="exp"
rp_module_flags="!mali !kms"

function depends_px68k() {
    getDepends sdl sdl_gfx
}

function sources_px68k() {
    gitPullOrClone
}

function build_px68k() {
    make clean
    make CC="clang" CXX="clang++" MOPT="" CDEBUGFLAGS="$CFLAGS -O2 -DUSE_SDLGFX -DNO_MERCURY"
    md_ret_require="$md_build/px68k"
}

function install_px68k() {
    md_ret_files=(
        'px68k'
        'readme.txt'
    )
}

function configure_px68k() {
    mkRomDir "x68000"

    moveConfigDir "$home/.keropi" "$md_conf_root/x68000"
    mkUserDir "$biosdir/keropi"

    local bios
    for bios in cgrom.dat iplrom30.dat iplromco.dat iplrom.dat iplromxv.dat; do
        if [[ -f "$biosdir/$bios" ]]; then
            mv "$biosdir/$bios" "$biosdir/keropi/$bios"
        fi
        ln -sf "$biosdir/keropi/$bios" "$md_conf_root/x68000/$bios"
    done

    addEmulator 1 "$md_id" "x68000" "$md_inst/px68k %ROM%"
    addSystem "x68000"
}
