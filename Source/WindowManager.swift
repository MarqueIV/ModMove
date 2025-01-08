import AppKit
import Foundation

final class WindowManager {

    enum Mode {
        case resize
        case drag
        case none
    }

    deinit {
        self.removeMonitor()
    }

    var mode: Mode = .none {
        didSet(oldMode) {

            guard mode != oldMode else { return }

            self.removeMonitor()

            switch mode {

                case .resize:
                    self.monitor = NSEvent.addGlobalMonitorForEvents(matching: .mouseMoved) { _ in
                        self.mouseMoved(handler: self.resizeWindow)
                    }

                case .drag:
                    self.monitor = NSEvent.addGlobalMonitorForEvents(matching: .mouseMoved) { _ in
                        self.mouseMoved(handler: self.moveWindow)
                    }

                case .none:
                    self.lastMousePosition = nil
                    self.targetWindow = nil
            }

        }
    }

    private var monitor: Any?
    private var lastMousePosition: CGPoint?
    private var targetWindow: AccessibilityElement?

    private func mouseMoved(handler: (_ window: AccessibilityElement, _ mouseDelta: CGPoint) -> Void) {

        let currentPosition = Mouse.currentPosition()

        if self.targetWindow == nil {
            self.targetWindow = AccessibilityElement.systemWideElement.element(at: currentPosition)?.window()
        }

        guard let window = self.targetWindow else { return }

        let currentPid = NSRunningApplication.current.processIdentifier
        if let pid = window.pid(), pid != currentPid {
            NSRunningApplication(processIdentifier: pid)?.activate(options: .activateIgnoringOtherApps)
        }

        window.bringToFront()
        if let lastPosition = self.lastMousePosition {

            let mouseDelta = CGPoint(
                x: lastPosition.x - currentPosition.x,
                y: lastPosition.y - currentPosition.y)

            handler(window, mouseDelta)
        }

        self.lastMousePosition = currentPosition
    }

    private func resizeWindow(window: AccessibilityElement, mouseDelta: CGPoint) {

        guard let size = window.size else { return }

        let newSize = CGSize(
            width: size.width - mouseDelta.x,
            height: size.height - mouseDelta.y)

        window.size = newSize
    }

    private func moveWindow(window: AccessibilityElement, mouseDelta: CGPoint) {
        if let position = window.position {
            let newPosition = CGPoint(x: position.x - mouseDelta.x, y: position.y - mouseDelta.y)
            window.position = newPosition
        }
    }

    private func removeMonitor() {

        guard let monitor else { return }

        NSEvent.removeMonitor(monitor)
        self.monitor = nil
    }
}
