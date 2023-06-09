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
        let clientHTTP = ClientHTTP(session: URLSession.shared)
        let sut = RemoteActivityLoader(clientHTTP: clientHTTP)
        let activity = try await sut.fetch()
        XCTAssertFalse(activity.activity.isEmpty)
    }
}
