#!/usr/bin/env bats
# Exercises install.sh end to end against throwaway directories.
# Run with: bats tests/install.bats

setup() {
  KIT="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
  INSTALL="$KIT/install.sh"
  WORK="$(mktemp -d)"
}

teardown() {
  rm -rf "$WORK"
}

expected_files() {
  cat <<'EOF'
AGENTS.md
CLAUDE.md
.github/copilot-instructions.md
.cursor/rules/agents.mdc
memory/MEMORY.md
memory/EXAMPLE.md
EOF
}

@test "fresh install copies every expected file" {
  run "$INSTALL" "$WORK"
  [ "$status" -eq 0 ]
  while IFS= read -r f; do
    [ -e "$WORK/$f" ] || { echo "missing: $f"; return 1; }
  done <<< "$(expected_files)"
}

@test "installed files are byte-identical to their templates" {
  "$INSTALL" "$WORK" >/dev/null
  diff "$WORK/AGENTS.md" "$KIT/templates/AGENTS.md"
  diff "$WORK/CLAUDE.md" "$KIT/templates/adapters/CLAUDE.md"
  diff "$WORK/.github/copilot-instructions.md" "$KIT/templates/adapters/.github/copilot-instructions.md"
  diff "$WORK/.cursor/rules/agents.mdc" "$KIT/templates/adapters/.cursor/rules/agents.mdc"
  diff "$WORK/memory/MEMORY.md" "$KIT/templates/memory/MEMORY.md"
  diff "$WORK/memory/EXAMPLE.md" "$KIT/templates/memory/EXAMPLE.md"
}

@test "default target is the current directory" {
  cd "$WORK"
  run "$INSTALL"
  [ "$status" -eq 0 ]
  [ -e "$WORK/AGENTS.md" ]
}

@test "re-run without --force is idempotent (skips existing files)" {
  "$INSTALL" "$WORK" >/dev/null
  echo "local edit" >> "$WORK/AGENTS.md"

  run "$INSTALL" "$WORK"
  [ "$status" -eq 0 ]
  [[ "$output" == *"skip   AGENTS.md"* ]]
  grep -q "local edit" "$WORK/AGENTS.md"
}

@test "--force overwrites existing files" {
  "$INSTALL" "$WORK" >/dev/null
  echo "local edit" >> "$WORK/AGENTS.md"

  run "$INSTALL" --force "$WORK"
  [ "$status" -eq 0 ]
  [[ "$output" == *"add    AGENTS.md"* ]]
  ! grep -q "local edit" "$WORK/AGENTS.md"
}

@test "rejects an unknown option" {
  run "$INSTALL" --nope "$WORK"
  [ "$status" -eq 2 ]
  [[ "$output" == *"unknown option"* ]]
}

@test "rejects multiple target directories instead of silently picking the last" {
  OTHER="$(mktemp -d)"
  run "$INSTALL" "$WORK" "$OTHER"
  [ "$status" -eq 2 ]
  [[ "$output" == *"multiple target directories"* ]]
  [ ! -e "$WORK/AGENTS.md" ]
  [ ! -e "$OTHER/AGENTS.md" ]
  rm -rf "$OTHER"
}

@test "errors when target directory does not exist" {
  run "$INSTALL" "$WORK/nope"
  [ "$status" -eq 1 ]
  [[ "$output" == *"does not exist"* ]]
}

@test "--help prints usage and exits 0" {
  run "$INSTALL" --help
  [ "$status" -eq 0 ]
  [[ "$output" == *"usage:"* ]]
}

@test "works under a strict POSIX sh (dash), not just bash" {
  command -v dash >/dev/null 2>&1 || skip "dash not installed"
  run dash "$INSTALL" "$WORK"
  [ "$status" -eq 0 ]
  [ -e "$WORK/AGENTS.md" ]
}
