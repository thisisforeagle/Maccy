import AppKit.NSEvent
import KeyboardShortcuts

struct KeyboardShortcutValidator {
  /// Shortcuts using only Option (± Shift) as modifiers produce visible characters
  /// on macOS (e.g., Option+C → "ç") and are blocked by the system in secure
  /// input contexts such as password fields.
  ///
  /// Returns `true` when the shortcut is expected to work everywhere,
  /// including password fields.
  static func isValidInPasswordFields(_ shortcut: KeyboardShortcuts.Shortcut?) -> Bool {
    guard let shortcut else { return true }

    let modifiers = shortcut.modifiers

    // Shortcuts that include Command or Control alongside any other modifiers
    // do not produce visible characters and are not blocked.
    if modifiers.contains(.command) || modifiers.contains(.control) {
      return true
    }

    // Option-only (with or without Shift) produces characters and is blocked.
    if modifiers.contains(.option) {
      return false
    }

    // No meaningful modifiers at all – likely a function key or similar;
    // treat as valid.
    return true
  }

  /// Human-readable warning for a shortcut that won't work in password fields.
  static func passwordFieldWarning(for shortcut: KeyboardShortcuts.Shortcut?) -> String? {
    if isValidInPasswordFields(shortcut) {
      return nil
    }
    return NSLocalizedString(
      "ShortcutBlockedInPasswordFields",
      tableName: "GeneralSettings",
      comment: ""
    )
  }
}
