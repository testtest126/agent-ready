#!/usr/bin/env sh
# moon.sh — print the current phase of the Moon. A tiny, dependency-free
# flourish for agent-ready; deliberately NOT wired into install.sh.
#
#   ./moon.sh [EPOCH_SECONDS]
#
# With no argument it uses the current time. Pass a Unix timestamp (whole
# seconds since 1970-01-01 UTC) to ask about any other moment — which is what
# makes it testable and lets you check a date that isn't today.

set -eu

# Reference new moon: 2000-01-06 18:14 UTC, as Unix epoch seconds.
KNOWN_NEW_MOON=947182440
# One synodic month (new moon to new moon): 29.53058867 days, in seconds.
SYNODIC=2551443

case "${1:-}" in
  -h|--help) echo "usage: $0 [EPOCH_SECONDS]"; exit 0 ;;
  -*) echo "unknown option: $1" >&2; exit 2 ;;
esac

# `date +%s` is a near-universal extension (GNU and BSD alike); there is no
# pure-POSIX way to read the current epoch. An explicit argument sidesteps it.
now="${1:-$(date +%s)}"

# Reject anything non-numeric up front so the arithmetic below can't misbehave.
case "$now" in
  '' | *[!0-9]*)
    echo "error: EPOCH_SECONDS must be a non-negative integer: '$now'" >&2
    exit 2
    ;;
esac

# Seconds elapsed into the current lunar cycle (0 .. SYNODIC-1). The extra
# +SYNODIC guards against a reference-preceding timestamp yielding a negative
# remainder before we normalise it.
elapsed=$(( ( (now - KNOWN_NEW_MOON) % SYNODIC + SYNODIC ) % SYNODIC ))

# Age of the Moon in whole days since the last new moon.
age=$(( elapsed / 86400 ))

# Snap to one of eight named phases. The +SYNODIC/2 rounds to the nearest
# segment centre, so a full moon lands on "Full Moon" rather than just past it.
phase=$(( (elapsed * 8 + SYNODIC / 2) / SYNODIC % 8 ))

case "$phase" in
  0) emoji="🌑"; name="New Moon" ;;
  1) emoji="🌒"; name="Waxing Crescent" ;;
  2) emoji="🌓"; name="First Quarter" ;;
  3) emoji="🌔"; name="Waxing Gibbous" ;;
  4) emoji="🌕"; name="Full Moon" ;;
  5) emoji="🌖"; name="Waning Gibbous" ;;
  6) emoji="🌗"; name="Last Quarter" ;;
  7) emoji="🌘"; name="Waning Crescent" ;;
esac

printf '%s  %s (day %d of ~29.5)\n' "$emoji" "$name" "$age"
