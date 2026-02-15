
import SnapshotTesting
import XCTest
@testable import Tracker

@MainActor
final class ScreenShotTests: XCTestCase {

    func testViewController() {
        let trackerVC = TrackersViewController()
        assertSnapshot(of: trackerVC, as: .image)
    }
}
