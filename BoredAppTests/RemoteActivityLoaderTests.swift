//
//  BoredAppTests.swift
//  BoredAppTests
//
//  Created by Marcelo Carvalho on 09/06/23.
//

import XCTest
@testable import BoredApp

final class RemoteActivityLoaderTests: XCTestCase {

    func testFetchActivity() async throws {
        let sut = RemoteActivityLoader()
        let activity = try await sut.fetch()
        XCTAssertFalse(activity.activity.isEmpty)
    }
}
