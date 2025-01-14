import AppKit
import Foundation

struct AccessibilityHelper {

    static func askForAccessibilityIfNeeded() {

        let key = kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String
        let options = [key: true]
        let accessibilityEnabled = AXIsProcessTrustedWithOptions(options as CFDictionary)

        if accessibilityEnabled { return }

//        let alert = NSAlert()
//        alert.messageText = "Enable Accessibility First"
//        alert.informativeText = "Find the popup right behind this one, click \"Open System Preferences\" and enable ModMove. Then launch ModMove again."
//        alert.alertStyle = .critical
//        alert.addButton(withTitle: "Quit")
//        alert.runModal()
//        NSApp.terminate(nil)
    }
}
