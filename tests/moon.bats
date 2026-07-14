#!/usr/bin/env bats
# Exercises moon.sh against fixed timestamps so every phase is deterministic.
# Run with: bats tests/moon.bats
#
# The offsets below are measured from the script's reference new moon
# (2000-01-06 18:14 UTC = epoch 947182440), one per eighth of the lunar cycle.

setup() {
  KIT="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
  MOON="$KIT/moon.sh"
}

@test "reference instant reads as a new moon" {
  run "$MOON" 947182440
  [ "$status" -eq 0 ]
  [[ "$output" == *"🌑"* ]]
  [[ "$output" == *"New Moon"* ]]
}

@test "quarter into the cycle reads as first quarter" {
  run "$MOON" 947820300
  [ "$status" -eq 0 ]
  [[ "$output" == *"🌓"* ]]
  [[ "$output" == *"First Quarter"* ]]
}

@test "half into the cycle reads as a full moon" {
  run "$MOON" 948458161
  [ "$status" -eq 0 ]
  [[ "$output" == *"🌕"* ]]
  [[ "$output" == *"Full Moon"* ]]
}

@test "past full but before last quarter reads as waning gibbous" {
  run "$MOON" 948777083
  [ "$status" -eq 0 ]
  [[ "$output" == *"🌖"* ]]
  [[ "$output" == *"Waning Gibbous"* ]]
}

@test "three quarters into the cycle reads as last quarter" {
  run "$MOON" 949096022
  [ "$status" -eq 0 ]
  [[ "$output" == *"🌗"* ]]
  [[ "$output" == *"Last Quarter"* ]]
}

@test "reports the moon's age in whole days" {
  run "$MOON" 948458161
  [ "$status" -eq 0 ]
  [[ "$output" == *"day 14 of ~29.5"* ]]
}

@test "no argument uses the current time and still succeeds" {
  run "$MOON"
  [ "$status" -eq 0 ]
  [[ "$output" == *"of ~29.5"* ]]
}

@test "a timestamp before the reference new moon does not crash" {
  run "$MOON" 0
  [ "$status" -eq 0 ]
  [[ "$output" == *"of ~29.5"* ]]
}

@test "rejects a non-numeric timestamp" {
  run "$MOON" abc
  [ "$status" -eq 2 ]
  [[ "$output" == *"non-negative integer"* ]]
}

@test "rejects an unknown option" {
  run "$MOON" --nope
  [ "$status" -eq 2 ]
  [[ "$output" == *"unknown option"* ]]
}

@test "--help prints usage and exits 0" {
  run "$MOON" --help
  [ "$status" -eq 0 ]
  [[ "$output" == *"usage:"* ]]
}

@test "works under a strict POSIX sh (dash), not just bash" {
  command -v dash >/dev/null 2>&1 || skip "dash not installed"
  run dash "$MOON" 948458161
  [ "$status" -eq 0 ]
  [[ "$output" == *"Full Moon"* ]]
}
