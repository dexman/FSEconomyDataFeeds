@testable import FSEconomyDataFeeds
import XCTest
import XMLCoder

func parseResponse<F: Feed>(_ type: F.Type, fromFileNamed name: String) throws -> F.ResponseType {
    guard let url = Bundle.module.url(forResource: "\(name).xml", withExtension: nil) else {
        throw URLError(.fileDoesNotExist)
    }
    let data = try Data(contentsOf: url)

    return try FeedClient.xmlDecoder.decode(F.ResponseType.self, from: data)
}
