import SwiftUI
import Defaults
import KeyboardShortcuts
import LaunchAtLogin
import Settings

struct GeneralSettingsPane: View {
  private let notificationsURL = URL(
    string: "x-apple.systempreferences:com.apple.preference.notifications?id=\(Bundle.main.bundleIdentifier ?? "")"
  )

  @Default(.searchMode) private var searchMode

  @State private var copyModifier = HistoryItemAction.copy.modifierFlags.description
  @State private var pasteModifier = HistoryItemAction.paste.modifierFlags.description
  @State private var pasteWithoutFormatting = HistoryItemAction.pasteWithoutFormatting.modifierFlags.description

  @State private var updater = SoftwareUpdater()

  @State private var popupWarning: String?
  @State private var pinWarning: String?
  @State private var deleteWarning: String?
  @State private var previewWarning: String?

  var body: some View {
    Settings.Container(contentWidth: 450) {
      Settings.Section(title: "", bottomDivider: true) {
        LaunchAtLogin.Toggle {
          Text("LaunchAtLogin", tableName: "GeneralSettings")
        }
        Toggle(isOn: $updater.automaticallyChecksForUpdates) {
          Text("CheckForUpdates", tableName: "GeneralSettings")
        }
        Button(
          action: { updater.checkForUpdates() },
          label: { Text("CheckNow", tableName: "GeneralSettings") }
        )
      }

      Settings.Section(label: { Text("Open", tableName: "GeneralSettings") }) {
        KeyboardShortcuts.Recorder(for: .popup, onChange: { newShortcut in
          if newShortcut == nil {
            // No shortcut is recorded. Remove keys monitor
            AppState.shared.popup.deinitEventsMonitor()
          } else {
            // User is using shortcut. Ensure keys monitor is initialized
            AppState.shared.popup.initEventsMonitor()
          }
          popupWarning = KeyboardShortcutValidator.passwordFieldWarning(for: newShortcut)
        })
          .help(Text("OpenTooltip", tableName: "GeneralSettings"))
        if let popupWarning {
          Text(popupWarning)
            .foregroundStyle(.orange)
            .controlSize(.small)
            .fixedSize(horizontal: false, vertical: true)
        }
      }

      Settings.Section(label: { Text("Pin", tableName: "GeneralSettings") }) {
        KeyboardShortcuts.Recorder(for: .pin, onChange: { newShortcut in
          pinWarning = KeyboardShortcutValidator.passwordFieldWarning(for: newShortcut)
        })
          .help(Text("PinTooltip", tableName: "GeneralSettings"))
        if let pinWarning {
          Text(pinWarning)
            .foregroundStyle(.orange)
            .controlSize(.small)
            .fixedSize(horizontal: false, vertical: true)
        }
      }
      Settings.Section(label: { Text("Delete", tableName: "GeneralSettings") }
      ) {
        KeyboardShortcuts.Recorder(for: .delete, onChange: { newShortcut in
          deleteWarning = KeyboardShortcutValidator.passwordFieldWarning(for: newShortcut)
        })
          .help(Text("DeleteTooltip", tableName: "GeneralSettings"))
        if let deleteWarning {
          Text(deleteWarning)
            .foregroundStyle(.orange)
            .controlSize(.small)
            .fixedSize(horizontal: false, vertical: true)
        }
      }
      Settings.Section(
        bottomDivider: true,
        label: { Text("ShowPreview", tableName: "GeneralSettings") }
      ) {
        KeyboardShortcuts.Recorder(for: .togglePreview, onChange: { newShortcut in
          previewWarning = KeyboardShortcutValidator.passwordFieldWarning(for: newShortcut)
        })
          .help(Text("ShowPreviewTooltip", tableName: "GeneralSettings"))
        if let previewWarning {
          Text(previewWarning)
            .foregroundStyle(.orange)
            .controlSize(.small)
            .fixedSize(horizontal: false, vertical: true)
        }
      }

      Settings.Section(
        bottomDivider: true,
        label: { Text("Search", tableName: "GeneralSettings") }
      ) {
        Picker("", selection: $searchMode) {
          ForEach(Search.Mode.allCases) { mode in
            Text(mode.description)
          }
        }
        .labelsHidden()
        .frame(width: 180, alignment: .leading)
      }

      Settings.Section(
        bottomDivider: true,
        label: { Text("Behavior", tableName: "GeneralSettings") }
      ) {
        Defaults.Toggle(key: .pasteByDefault) {
          Text("PasteAutomatically", tableName: "GeneralSettings")
        }
        .onChange(refreshModifiers)
        .fixedSize()

        Defaults.Toggle(key: .removeFormattingByDefault) {
          Text("PasteWithoutFormatting", tableName: "GeneralSettings")
        }
        .onChange(refreshModifiers)
        .fixedSize()

        Text(String(
          format: NSLocalizedString("Modifiers", tableName: "GeneralSettings", comment: ""),
          copyModifier, pasteModifier, pasteWithoutFormatting
        ))
        .fixedSize(horizontal: false, vertical: true)
        .foregroundStyle(.gray)
        .controlSize(.small)
      }

      Settings.Section(title: "") {
        if let notificationsURL = notificationsURL {
          Link(destination: notificationsURL, label: {
            Text("NotificationsAndSounds", tableName: "GeneralSettings")
          })
        }
      }
    }
    .onAppear {
      validateShortcuts()
    }
  }

  private func refreshModifiers(_ sender: Sendable) {
    copyModifier = HistoryItemAction.copy.modifierFlags.description
    pasteModifier = HistoryItemAction.paste.modifierFlags.description
    pasteWithoutFormatting = HistoryItemAction.pasteWithoutFormatting.modifierFlags.description
  }

  private func validateShortcuts() {
    popupWarning = KeyboardShortcutValidator.passwordFieldWarning(
      for: KeyboardShortcuts.Shortcut(name: .popup)
    )
    pinWarning = KeyboardShortcutValidator.passwordFieldWarning(
      for: KeyboardShortcuts.Shortcut(name: .pin)
    )
    deleteWarning = KeyboardShortcutValidator.passwordFieldWarning(
      for: KeyboardShortcuts.Shortcut(name: .delete)
    )
    previewWarning = KeyboardShortcutValidator.passwordFieldWarning(
      for: KeyboardShortcuts.Shortcut(name: .togglePreview)
    )
  }
}

#Preview {
  GeneralSettingsPane()
    .environment(\.locale, .init(identifier: "en"))
}
