import Cocoa

@NSApplicationMain
final class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ notification: Notification) {

        AccessibilityHelper.askForAccessibilityIfNeeded()

        if !LoginController.opensAtLogin() {
            LoginAlert.showAlertIfNeeded()
        }

        let mover = WindowManager()
        Observer().startObserving { state in
            mover.mode = state
        }
    }

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        sender.orderFrontStandardAboutPanel(nil)
        return true
    }
}
