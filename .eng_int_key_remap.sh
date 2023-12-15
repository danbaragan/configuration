#!/bin/bash

# credits to https://keystrokecountdown.com/articles/keymaps/index.html
FROM='"HIDKeyboardModifierMappingSrc"'
TO='"HIDKeyboardModifierMappingDst"'

ARGS=""
function Map # FROM TO
{
    CMD="${CMD:+${CMD},}{${FROM}: ${1}, ${TO}: ${2}}"
}

BACKQUOTE="0x700000035"
SHIFT_LOCK="0x700000039"
SECTION="0x700000064"
L_SHIFT="0x7000000E1"
R_COMMAND="0x7000000E7"
L_CONTROL="0x7000000E0"

Map ${SECTION} ${BACKQUOTE}
Map ${BACKQUOTE} ${L_SHIFT}

hidutil property --set "{\"UserKeyMapping\":[${CMD}]}" >/dev/null 2>&1

