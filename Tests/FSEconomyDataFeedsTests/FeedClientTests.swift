@testable import FSEconomyDataFeeds
import XCTest

final class FeedClientTests: XCTestCase {
    func testSuccessParsing() async throws {
        let session = TestURLSession()
        session.expectedURLs["https://server.fseconomy.net/data?userkey=DEADBEEF&format=xml"] = (
            "<TestResponse><item>a</item><item>b</item></TestResponse>".data(using: .utf8) ?? Data(),
            URLResponse()
        )

        let client = FeedClient(userKey: "DEADBEEF", session: session)
        _ = try await client.request(TestFeed())
    }

    func testErrorParsing() async throws {
        let session = TestURLSession()
        session.expectedURLs["https://server.fseconomy.net/data?userkey=DEADBEEF&format=xml&query=icao&search=jobsto&icaos=KDFW"] = (
            "<Error>Test error message</Error>".data(using: .utf8) ?? Data(),
            URLResponse()
        )

        let client = FeedClient(userKey: "DEADBEEF", session: session)

        do {
            _ = try await client.request(Feeds.ICAOJobsFeed(.to, icaos: "KDFW"))
            XCTFail()
        } catch let error as FeedClient.Error {
            XCTAssertEqual(error.message, "Test error message")
        }
    }

    func testAirportsParsing() async throws {
        let session = TestURLSession()
        session.expectedURLs["https://server.fseconomy.net/static/library/datafeed_icaodata.zip"] = (
            try Data(contentsOf: Bundle.module.url(forResource: "datafeed_icaodata.zip", withExtension: nil)!),
            URLResponse()
        )

        let client = FeedClient(userKey: "DEADBEEF", session: session)
        let airports = try await client.request(Feeds.AirportsFeed())
        XCTAssertEqual(airports.count, 23760)
        XCTAssertEqual(airports.first, Airport(
            icao: "0E0",
            lat: 34.9856,
            lon: -106.009,
            type: .civil,
            size: 2343,
            name: "Moriarty",
            city: "Moriarty",
            state: "New Mexico",
            country: "United States"
        ))
    }
}

private struct TestFeed: Feed {
    typealias ResponseType = TestResponse

    let queryItems: [URLQueryItem] = []
}

private struct TestResponse: Decodable {
    let item: [String]
}

private final class TestURLSession: FeedClientURLSession {

    var expectedURLs: [String: (Data, URLResponse)] {
        get {
            queue.sync { unsafeExpectedURLs }
        }
        set {
            queue.sync { unsafeExpectedURLs = newValue }
        }
    }

    func data(from url: URL) async throws -> (Data, URLResponse) {
        guard let response = expectedURLs[url.absoluteString] else {
            throw URLError(.badURL)
        }
        return response
    }

    private let queue = DispatchQueue(label: "TestURLSession")
    private var unsafeExpectedURLs: [String: (Data, URLResponse)] = [:]
}
