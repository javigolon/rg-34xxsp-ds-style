#!/bin/sh
#

#
# Game Rooms option is not implemented yet.

set -u

BASE=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd) || exit 1
ROOT=${DS_STYLE_TEST_ROOT:-}
MODE=${1:-}
ROM=${2:-}

mkdir -p "$BASE/state" || exit 1
LOG="$BASE/state/last-launch.txt"

[ "$MODE" = plan ] || [ ! -x "$BASE/bin/dsstyle-stock-state" ] || \
    "$BASE/bin/dsstyle-stock-state" "$BASE" save
trap '[ "$MODE" = plan ] || [ ! -x "$BASE/bin/dsstyle-stock-state" ] || "$BASE/bin/dsstyle-stock-state" "$BASE" save' EXIT

fail() {
    printf '%s\n' "$*" > "$LOG"
    exit 20
}

. "$BASE/scripts/stock-profile.sh"

COREDIR="$ROOT/mnt/vendor/deep/retro/cores"
WRAPPER="$ROOT/mnt/mod/ctrl/RA_launch.sh"

core_exists() {
    [ -f "$COREDIR/$1" ]
}

first_installed_core() {
    for c in "$@"; do
        if core_exists "$c"; then
            printf '%s\n' "$c"
            return 0
        fi
    done
    return 1
}

# Resolve a RetroArch core for a Roms/<SYSTEM> folder.
resolve_core() {
    # Optional per-system override:
    #   DSStyle/state/core-overrides/<SYSTEM>.txt
    # The text file should contains a core filename such as:
    #   mgba_libretro.so
    OVERRIDE="$BASE/state/core-overrides/$SYS.txt"
    if [ -f "$OVERRIDE" ]; then
        IFS= read -r CORE < "$OVERRIDE" || CORE=
        CORE=$(printf '%s' "$CORE" | tr -d '\r')
        case "$CORE" in
            ''|*[!A-Za-z0-9_.-]*|.*)
                fail "Invalid core override for $SYS."
                ;;
        esac
        core_exists "$CORE" || fail "Configured core for $SYS is missing: $CORE"
        printf '%s\n' "$CORE"
        return 0
    fi

    case "$SYS" in
        GBA)
            first_installed_core \
                mgba_libretro.so gpsp_libretro.so vbam_libretro.so vba_next_libretro.so
            ;;
        GB|GBC)
            first_installed_core \
                gambatte_libretro.so sameboy_libretro.so gearboy_libretro.so tgbdual_libretro.so
            ;;
        FC|NES|FAMICOM|FDS)
            first_installed_core \
                fceumm_libretro.so nestopia_libretro.so quicknes_libretro.so
            ;;
        SFC|SNES)
            first_installed_core \
                snes9x_libretro.so snes9x2010_libretro.so snes9x2005_plus_libretro.so \
                snes9x2005_libretro.so snes9x2002_libretro.so
            ;;
        MD|GENESIS|MDCD|SEGA32X|SMS|GG|SG-1000)
            first_installed_core genesis_plus_gx_libretro.so picodrive_libretro.so
            ;;
        PCE|PCECD)
            first_installed_core mednafen_pce_fast_libretro.so
            ;;
        NGP|NGPC)
            first_installed_core mednafen_ngp_libretro.so
            ;;
        NEOCD)
            first_installed_core neocd_libretro.so
            ;;
        NEOGEO|FBNEO|PGM2|HBMAME|VARCADE)
            first_installed_core \
                fbneo_libretro.so fbneo_G_libretro.so fbalpha2012_neogeo_libretro.so \
                fbalpha2012_libretro.so
            ;;
        CPS1)
            first_installed_core \
                fbneo_libretro.so fbalpha2012_cps1_libretro.so fbalpha2012_libretro.so
            ;;
        CPS2)
            first_installed_core \
                fbneo_libretro.so fbalpha2012_cps2_libretro.so fbalpha2012_libretro.so
            ;;
        CPS3)
            first_installed_core \
                fbneo_libretro.so fbalpha2012_cps3_libretro.so fbalpha2012_libretro.so
            ;;
        MAME)
            first_installed_core \
                mame2003_plus_libretro.so mame2003_xtreme_libretro.so \
                mame2010_libretro.so mame2022xtreme_libretro.so mame2000_libretro.so
            ;;
        PS|PSX)
            first_installed_core \
                pcsx_rearmed_libretro.so pcsx_rearmed_rumble_libretro.so \
                pcsx_rearmed_peops_libretro.so pcsx_rearmed_rumble_peops_libretro.so \
                swanstation_libretro.so
            ;;
        N64)
            first_installed_core mupen64plus_next_libretro.so parallel_n64_libretro.so
            ;;
        DREAMCAST|NAOMI|ATOMISWAVE)
            first_installed_core flycast_libretro.so flycast_xtreme_libretro.so
            ;;
        SATURN)
            first_installed_core yabasanshiro_libretro.so
            ;;
        WS|WSC)
            first_installed_core mednafen_wswan_libretro.so
            ;;
        VB)
            first_installed_core mednafen_vb_libretro.so
            ;;
        GW)
            first_installed_core gw_libretro.so
            ;;
        POKE|POKEMINI)
            first_installed_core pokemini_libretro.so
            ;;
        A2600)
            first_installed_core stella2014_libretro.so
            ;;
        A5200)
            first_installed_core a5200_libretro.so atari800_libretro.so
            ;;
        A7800)
            first_installed_core prosystem_libretro.so
            ;;
        A800)
            first_installed_core atari800_libretro.so
            ;;
        ATARIST)
            first_installed_core hatari_libretro.so
            ;;
        LYNX)
            first_installed_core handy_libretro.so
            ;;
        AMIGA)
            first_installed_core puae_libretro.so
            ;;
        C64)
            first_installed_core vice_x64_libretro.so
            ;;
        C128)
            first_installed_core vice_x128_libretro.so
            ;;
        PLUS4)
            first_installed_core vice_xplus4_libretro.so
            ;;
        VIC20)
            first_installed_core vice_xvic_libretro.so
            ;;
        MSX|COLECO)
            first_installed_core bluemsx_libretro.so
            ;;
        DOS)
            first_installed_core dosbox_pure_libretro.so
            ;;
        EASYRPG)
            first_installed_core easyrpg_libretro.so
            ;;
        SCUMMVM)
            first_installed_core scummvm_libretro.so
            ;;
        PORTS)
            # Stock RA_launch.sh has special handling for shell ports.
            printf '%s\n' ports
            ;;
        PSP|NDS|PICO|OPENBOR|SCV)
            return 2
            ;;
        *)
            return 1
            ;;
    esac
}

launch_retroarch_game() {
    [ -f "$WRAPPER" ] || fail '/mnt/mod/ctrl/RA_launch.sh was not found.'

    CORE=$(resolve_core)
    RC=$?
    case "$RC" in
        0) ;;
        2)
        # Game Rooms option is not implemented yet.
            fail "$SYS Game Rooms Error"
            ;;
        *)
            fail "No installed RetroArch core mapping was found for $SYS."
            ;;
    esac

    {
        echo 'Log'
        printf 'System: %s\n' "$SYS"
        printf 'ROM: %s\n' "$ROM"
        printf 'Core: %s\n' "$CORE"
        printf 'Wrapper: %s\n' "$WRAPPER"
    } > "$LOG"

    if [ "$MODE" = plan ]; then
        cat "$LOG"
        return 0
    fi

    /bin/bash "$WRAPPER" "$CORE" "$ROM" >> "$LOG" 2>&1
    RC=$?
    printf '\nStock launcher exit code: %s\n' "$RC" >> "$LOG"
    return "$RC"
}

case "$MODE" in
    retroarch)
        SYS=__MENU
        prepare_profile
        printf 'Open existing stock config: %s\nHOME policy: %s\n' "$CFG" "$PROFILE_HOME" > "$LOG"
        run_profile >> "$LOG" 2>&1
        ;;

    ppsspp)
        EXE="$ROOT/mnt/vendor/deep/ppsspp/PPSSPPSDL"
        [ -x "$EXE" ] || fail 'Stock PPSSPP executable was not found.'
        printf 'Open stock PPSSPP: %s\n' "$EXE" > "$LOG"
        cd "$ROOT/mnt/vendor/deep/ppsspp" || exit 20
        "$EXE" >> "$LOG" 2>&1
        ;;

    app)
        case "$ROM" in
            "$ROOT/mnt/mmc/Roms/APPS/"*.sh|"$ROOT/mnt/sdcard/Roms/APPS/"*.sh) ;;
            *) fail 'App must be an installed APPS shell script.' ;;
        esac
        [ -f "$ROM" ] || fail 'App was not found.'
        printf 'Stock app: %s\n' "$ROM" > "$LOG"
        cd "$(dirname -- "$ROM")" || exit 20
        FIRST=$(head -n 1 "$ROM")
        case "$FIRST" in *bash*) SHELL_APP=/bin/bash ;; *) SHELL_APP=/bin/sh ;; esac
        "$SHELL_APP" "$ROM" >> "$LOG" 2>&1
        ;;

    game|plan)
        [ -f "$ROM" ] || fail 'ROM was not found.'

        case "$ROM" in
            "$ROOT/mnt/mmc/Roms/"*) REL=${ROM#"$ROOT/mnt/mmc/Roms/"} ;;
            "$ROOT/mnt/sdcard/Roms/"*) REL=${ROM#"$ROOT/mnt/sdcard/Roms/"} ;;
            *) fail 'ROM must be inside a stock Roms directory.' ;;
        esac

        SYS=${REL%%/*}
        [ "$SYS" != "$REL" ] || fail 'Place ROMs inside a system folder such as Roms/GBA.'
        case "$REL" in ../*|*/../*|./*|*/./*) fail 'ROM path must not contain traversal components.' ;; esac
        case "$SYS" in *[!A-Za-z0-9_-]*) fail 'Unsupported system folder name.' ;; esac

        CHOICE=retroarch
        if [ -f "$BASE/state/launch-modes/$SYS.txt" ]; then
            IFS= read -r CHOICE < "$BASE/state/launch-modes/$SYS.txt" || true
            CHOICE=$(printf '%s' "$CHOICE" | tr -d '\r')
        fi

        case "${3:-}" in
            stock-room) CHOICE=gameroom ;;
            stock-ra)   CHOICE=retroarch ;;
            '')         : ;;
            *)          fail 'Invalid stock collection route.' ;;
        esac

        if [ "$CHOICE" = gameroom ]; then
            # Game Rooms option is not implemented yet.
            fail 'Game Rooms option is not supported yet. Set this system to RetroArch.'
        fi

        [ "$CHOICE" = retroarch ] || fail 'Invalid saved launch mode.'
        launch_retroarch_game
        exit $?
        ;;

    *)
        fail "Unknown launch mode: $MODE"
        ;;
esac

RC=$?
printf '\nApplication exit code: %s\n' "$RC" >> "$LOG"
exit "$RC"
