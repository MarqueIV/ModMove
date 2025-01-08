import CoreGraphics

struct Mouse {

    static func currentPosition() -> CGPoint {
        let mouseEventSource = CGEvent(source: nil)!
        return mouseEventSource.location
    }

//    static func isButtonPressed(_ mouseButton: CGMouseButton) -> Bool {
//        CGEventSource.keyState(.hidSystemState, key: UInt16(mouseButton.rawValue))
//    }
}
