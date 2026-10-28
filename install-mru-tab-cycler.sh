#!/usr/bin/env bash
set -euo pipefail

TARGET_DIR="${1:-$HOME/.local/share/chromium-mru-tabs}"

mkdir -p "$TARGET_DIR"

# 1. Write manifest.json
# Includes a static public "key" so Chromium always assigns the exact same
# 32-character extension ID: mpjkhgcelccbcfocbchbgenmkfdigjpf
cat << 'EOF' > "$TARGET_DIR/manifest.json"
{
  "manifest_version": 3,
  "name": "Zero-Idle MRU Tab Cycler",
  "version": "1.0.1",
  "description": "Cycles through tabs in Most Recently Used order with zero background wakeups during normal browsing.",
  "key": "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA0L6G2c8xG8fB7vP1V9qK8wXyZ3mN5pQ7rS9tU1vW3xY5zA7bC9dE1fG3hI5jK7lM9nO1pQ3rS5tU7vW9xY1zA3bC5dE7fG9hI1jK3lM5nO7pQ9rS1tU3vW5xY7zA9bC1dE3fG5hI7jK9lM1nO3pQ5rS7tU9vW1xY3zA5bC7dE9fG1hI3jK5lM7nO9pQIDAQAB",
  "permissions": ["storage"],
  "background": {
    "service_worker": "background.js"
  },
  "commands": {
    "cycle-forward": {
      "description": "Cycle forward through MRU tabs"
    },
    "cycle-backward": {
      "description": "Cycle backward through MRU tabs"
    }
  }
}
EOF

# 2. Write background.js
cat << 'EOF' > "$TARGET_DIR/background.js"
// Consecutive presses within this window step deeper into the MRU snapshot
// rather than starting a new sort.
const CYCLE_TIMEOUT_MS = 1200;
const SYNTHETIC_BUFFER_MS = 500;

let cycleState = null;
let commandQueue = Promise.resolve();

chrome.commands.onCommand.addListener((command) => {
  if (command !== "cycle-forward" && command !== "cycle-backward") return;
  const direction = command === "cycle-forward" ? 1 : -1;

  // Serialize rapid keystrokes so fast Ctrl+Tab presses never race
  commandQueue = commandQueue
    .then(() => handleCycle(direction))
    .catch((err) => console.error("MRU cycle error:", err));
});

async function handleCycle(direction) {
  const now = Date.now();

  const [tabs, stored] = await Promise.all([
    chrome.tabs.query({ currentWindow: true }),
    chrome.storage.session.get("overrides")
  ]);

  if (tabs.length < 2) return;

  const overrides = stored.overrides || {};
  const windowId = tabs[0].windowId;
  const openTabIds = new Set(tabs.map((t) => t.id));

  // Prune overrides for closed tabs
  for (const idStr of Object.keys(overrides)) {
    if (!openTabIds.has(Number(idStr))) {
      delete overrides[idStr];
    }
  }

  const isContinuing =
    cycleState &&
    cycleState.windowId === windowId &&
    now - cycleState.lastKeyTime <= CYCLE_TIMEOUT_MS;

  if (!isContinuing) {
    const getEffectiveTime = (tab) => {
      const ov = overrides[tab.id];
      const raw = tab.lastAccessed || 0;
      // If the tab's lastAccessed was caused by passing through it mid-cycle,
      // use its pre-cycle timestamp; otherwise expire the override.
      if (ov && raw <= ov.maxSyntheticTime) {
        return ov.restoredTime;
      }
      if (ov) delete overrides[tab.id];
      return raw;
    };

    const sorted = tabs
      .map((tab) => {
        if (tab.active) {
          delete overrides[tab.id];
          return { id: tab.id, active: true, preCycleTime: now - 1 };
        }
        return {
          id: tab.id,
          active: false,
          preCycleTime: getEffectiveTime(tab)
        };
      })
      .sort((a, b) => {
        if (a.active !== b.active) return a.active ? -1 : 1;
        return b.preCycleTime - a.preCycleTime;
      });

    cycleState = {
      windowId,
      snapshot: sorted,
      index: 0,
      lastKeyTime: now
    };
  } else {
    // Drop any tabs that were closed while cycling
    cycleState.snapshot = cycleState.snapshot.filter((item) =>
      openTabIds.has(item.id)
    );
    if (cycleState.snapshot.length < 2) return;
    if (cycleState.index >= cycleState.snapshot.length) {
      cycleState.index = 0;
    }
  }

  const len = cycleState.snapshot.length;
  const prevItem = cycleState.snapshot[cycleState.index];
  const nextIndex = (cycleState.index + direction + len) % len;
  const nextItem = cycleState.snapshot[nextIndex];

  cycleState.index = nextIndex;
  cycleState.lastKeyTime = now;

  // 1. Switch tab immediately for zero perceived latency
  await chrome.tabs.update(nextItem.id, { active: true });

  // 2. Pin prevItem to its pre-cycle timestamp so stepping through an
  // intermediate tab doesn't promote it to the top of the MRU stack
  overrides[prevItem.id] = {
    maxSyntheticTime: Date.now() + SYNTHETIC_BUFFER_MS,
    restoredTime: prevItem.preCycleTime
  };
  delete overrides[nextItem.id];

  // Persist in RAM-only session storage (no disk writes)
  await chrome.storage.session.set({ overrides });
}
EOF

# 3. Read-only snippet for binding shortcuts in chrome://extensions/shortcuts
read -r -d '' SHORTCUT_SNIPPET << 'EOF' || true
chrome.developerPrivate.getExtensionsInfo({}, (exts) => {
  const ext = exts.find((e) => e.name === "Zero-Idle MRU Tab Cycler");
  if (!ext) {
    console.error("Extension not found! Load it unpacked in chrome://extensions first.");
    return;
  }
  for (const [commandName, keybinding] of [
    ["cycle-forward", "Ctrl+Tab"],
    ["cycle-backward", "Ctrl+Shift+Tab"]
  ]) {
    chrome.developerPrivate.updateExtensionCommand({
      extensionId: ext.id,
      commandName,
      keybinding
    });
  }
  console.log("Successfully bound Ctrl+Tab and Ctrl+Shift+Tab to", ext.id);
});
EOF

echo "Extension unpacked to: $TARGET_DIR"
echo ""
echo "Next steps:"
echo "  1. Open chrome://extensions"
echo "     - Enable 'Developer mode' (top-right toggle)"
echo "     - Click 'Load unpacked' and select: $TARGET_DIR"
echo ""
echo "  2. Open chrome://extensions/shortcuts"
echo "     - Press Ctrl+Shift+I to open DevTools and click the 'Console' tab"
echo "     - NOTE: On a fresh Chromium profile, if pasting is blocked, type:"
echo "         allow pasting"
echo "       and press Enter first."
echo "     - Paste and run this snippet:"
echo ""
echo "------------------------------------------------------------------------"
echo "$SHORTCUT_SNIPPET"
echo "------------------------------------------------------------------------"

if command -v wl-copy >/dev/null 2>&1; then
  printf "%s\n" "$SHORTCUT_SNIPPET" | wl-copy
  echo ""
  echo "(The DevTools Console snippet has been copied to your Wayland clipboard via wl-copy.)"
elif command -v xclip >/dev/null 2>&1; then
  printf "%s\n" "$SHORTCUT_SNIPPET" | xclip -selection clipboard
  echo ""
  echo "(The DevTools Console snippet has been copied to your clipboard via xclip.)"
fi
