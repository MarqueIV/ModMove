import AppKit
import Foundation

final class Observer {

    let moveFlags: NSEvent.ModifierFlags = [.control, .command]
    let sizeFlags: NSEvent.ModifierFlags = [.control, .command, .option]

    private var monitor: Any?

    func startObserving(stateHandler: @escaping (WindowManager.Mode) -> Void) {

        self.monitor = NSEvent.addGlobalMonitorForEvents(matching: .flagsChanged) { event in
            let state = self.getMode(for: event.modifierFlags)
            stateHandler(state)
        }
    }

    private func getMode(for flags: NSEvent.ModifierFlags) -> WindowManager.Mode {

        // Mask out only those we are interested in, making comparison easier/simpler
        let maskedFlags = flags.intersection([.command, .shift, .control, .option])

        return switch maskedFlags {
            case moveFlags: .drag
            case sizeFlags: .resize
            default: .none
        }
    }

    deinit {
        guard let monitor else { return }
        NSEvent.removeMonitor(monitor)
    }
}
