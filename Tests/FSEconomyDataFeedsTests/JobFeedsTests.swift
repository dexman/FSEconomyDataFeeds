@testable import FSEconomyDataFeeds
import XCTest

final class JobFeedsTests: XCTestCase {

    func testJobsToOne() {
        let feed = Feeds.ICAOJobsFeed(.to, icaos: ["CZFA"])
        XCTAssertEqual(feed.queryItems, [
            URLQueryItem(name: "query", value: "icao"),
            URLQueryItem(name: "search", value: "jobsto"),
            URLQueryItem(name: "icaos", value: "CZFA"),
        ])
    }

    func testJobsToMany() {
        let feed = Feeds.ICAOJobsFeed(.to, icaos: ["CZFA", "CEX4", "CYMA"])
        XCTAssertEqual(feed.queryItems, [
            URLQueryItem(name: "query", value: "icao"),
            URLQueryItem(name: "search", value: "jobsto"),
            URLQueryItem(name: "icaos", value: "CZFA-CEX4-CYMA"),
        ])
    }

    func testJobsFromOne() {
        let feed = Feeds.ICAOJobsFeed(.from, icaos: ["CZFA"])
        XCTAssertEqual(feed.queryItems, [
            URLQueryItem(name: "query", value: "icao"),
            URLQueryItem(name: "search", value: "jobsfrom"),
            URLQueryItem(name: "icaos", value: "CZFA"),
        ])
    }

    func testJobsFromMany() {
        let feed = Feeds.ICAOJobsFeed(.from, icaos: ["CZFA", "CEX4", "CYMA"])
        XCTAssertEqual(feed.queryItems, [
            URLQueryItem(name: "query", value: "icao"),
            URLQueryItem(name: "search", value: "jobsfrom"),
            URLQueryItem(name: "icaos", value: "CZFA-CEX4-CYMA"),
        ])
    }

    func testICAOJobsFeedParsing() throws {
        let response = try parseResponse(Feeds.ICAOJobsFeed.self, fromFileNamed: "ICAOJobsData")
        XCTAssertEqual(response.total, 50)
        XCTAssertEqual(response.assignment.count, 50)
        XCTAssertEqual(response.assignment.first, ICAOJobs.Assignment(
            id: "366688798",
            location: "19AK",
            toIcao: "CEX4",
            fromIcao: "19AK",
            amount: 1,
            unitType: .passengers,
            commodity: "UGP UX32 &#10052;&#65039;",
            pay: 922.0,
            expires: "1 days",
            expireDateTime: ISO8601DateFormatter().date(from: "2022-10-31T08:31:03+00:00")!,
            express: false,
            ptAssignment: true,
            type: .tripOnly,
            aircraftId: "0"
        ))
    }
}
