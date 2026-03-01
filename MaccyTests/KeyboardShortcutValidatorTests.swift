import XCTest
import KeyboardShortcuts
import Carbon.HIToolbox
@testable import Maccy

class KeyboardShortcutValidatorTests: XCTestCase {
  // MARK: - Shortcuts that should be valid in password fields

  func testCommandShiftCIsValid() {
    let shortcut = KeyboardShortcuts.Shortcut(.c, modifiers: [.command, .shift])
    XCTAssertTrue(KeyboardShortcutValidator.isValidInPasswordFields(shortcut))
  }

  func testCommandCIsValid() {
    let shortcut = KeyboardShortcuts.Shortcut(.c, modifiers: [.command])
    XCTAssertTrue(KeyboardShortcutValidator.isValidInPasswordFields(shortcut))
  }

  func testControlSpaceIsValid() {
    let shortcut = KeyboardShortcuts.Shortcut(.space, modifiers: [.control])
    XCTAssertTrue(KeyboardShortcutValidator.isValidInPasswordFields(shortcut))
  }

  func testCommandOptionCIsValid() {
    let shortcut = KeyboardShortcuts.Shortcut(.c, modifiers: [.command, .option])
    XCTAssertTrue(KeyboardShortcutValidator.isValidInPasswordFields(shortcut))
  }

  func testCommandOptionShiftVIsValid() {
    let shortcut = KeyboardShortcuts.Shortcut(.v, modifiers: [.command, .option, .shift])
    XCTAssertTrue(KeyboardShortcutValidator.isValidInPasswordFields(shortcut))
  }

  func testControlOptionCIsValid() {
    let shortcut = KeyboardShortcuts.Shortcut(.c, modifiers: [.control, .option])
    XCTAssertTrue(KeyboardShortcutValidator.isValidInPasswordFields(shortcut))
  }

  func testNilShortcutIsValid() {
    XCTAssertTrue(KeyboardShortcutValidator.isValidInPasswordFields(nil))
  }

  // MARK: - Shortcuts that should be blocked in password fields

  func testOptionCIsBlocked() {
    let shortcut = KeyboardShortcuts.Shortcut(.c, modifiers: [.option])
    XCTAssertFalse(KeyboardShortcutValidator.isValidInPasswordFields(shortcut))
  }

  func testOptionPIsBlocked() {
    let shortcut = KeyboardShortcuts.Shortcut(.p, modifiers: [.option])
    XCTAssertFalse(KeyboardShortcutValidator.isValidInPasswordFields(shortcut))
  }

  func testOptionShiftCIsBlocked() {
    let shortcut = KeyboardShortcuts.Shortcut(.c, modifiers: [.option, .shift])
    XCTAssertFalse(KeyboardShortcutValidator.isValidInPasswordFields(shortcut))
  }

  func testOptionDeleteIsBlocked() {
    let shortcut = KeyboardShortcuts.Shortcut(.delete, modifiers: [.option])
    XCTAssertFalse(KeyboardShortcutValidator.isValidInPasswordFields(shortcut))
  }

  // MARK: - Warning message

  func testWarningIsNilForValidShortcut() {
    let shortcut = KeyboardShortcuts.Shortcut(.c, modifiers: [.command, .shift])
    XCTAssertNil(KeyboardShortcutValidator.passwordFieldWarning(for: shortcut))
  }

  func testWarningExistsForBlockedShortcut() {
    let shortcut = KeyboardShortcuts.Shortcut(.c, modifiers: [.option])
    XCTAssertNotNil(KeyboardShortcutValidator.passwordFieldWarning(for: shortcut))
  }

  func testWarningIsNilForNilShortcut() {
    XCTAssertNil(KeyboardShortcutValidator.passwordFieldWarning(for: nil))
  }
}
