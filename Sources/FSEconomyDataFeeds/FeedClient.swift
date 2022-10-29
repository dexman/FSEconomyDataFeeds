import Foundation
import CSV
import XMLCoder
import ZIPFoundation

public struct FeedClient {

    public struct Error: Swift.Error, LocalizedError {
        public let message: String

        public var errorDescription: String? { message }
    }

    public init(userKey: String, session: FeedClientURLSession? = nil) {
        self.userKey = userKey
        self.session = session ?? URLSession.shared
    }

    public func request<F>( _ feed: F) async throws -> F.ResponseType where F: Feed {
        guard var urlComponents = URLComponents(string: "https://server.fseconomy.net/data") else {
            throw URLError(.badURL)
        }

        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "userkey", value: userKey),
            URLQueryItem(name: "format", value: "xml"),
        ]
        queryItems.append(contentsOf: feed.queryItems)
        urlComponents.queryItems = queryItems

        guard let url = urlComponents.url else {
            throw URLError(.badURL)
        }

        let (data, _) = try await session.data(from: url)

        guard !data.starts(with: "<Error>".data(using: .utf8) ?? Data()) else {
            let errorMessage = try Self.xmlDecoder.decode(String.self, from: data)
            throw Error(message: errorMessage)
        }

        return try Self.xmlDecoder.decode(F.ResponseType.self, from: data)
    }

    public func request( _ feed: Feeds.AirportsFeed) async throws -> [Airport] {
        guard let url = URL(string: "https://server.fseconomy.net/static/library/datafeed_icaodata.zip") else {
            throw URLError(.badURL)
        }

        let (data, _) = try await session.data(from: url)

        // unzip
        guard let archive = Archive(data: data, accessMode: .read) else {
            throw CocoaError(.fileReadCorruptFile)
        }
        guard let entry = archive["icaodata.csv"] else {
            throw CocoaError(.fileNoSuchFile)
        }
        var csvData = Data()
        _ = try archive.extract(entry) {
            csvData.append(contentsOf: $0)
        }

        // decode CSV
        var airports: [Airport] = []
        let reader = try CSVReader(stream: InputStream(data: csvData), hasHeaderRow: true)
        let decoder = CSVRowDecoder()
        while reader.next() != nil {
            let row = try decoder.decode(Airport.self, from: reader)
            airports.append(row)
        }

        return airports
    }

    static var xmlDecoder: XMLDecoder {
        let decoder = XMLDecoder()
        decoder.keyDecodingStrategy = .convertFromCapitalized
        decoder.dateDecodingStrategy = .formatted({
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            return dateFormatter
        }())
        return decoder
    }

    private let userKey: String
    private let session: FeedClientURLSession
}

public protocol FeedClientURLSession {
    func data(from url: URL) async throws -> (Data, URLResponse)
}

extension URLSession: FeedClientURLSession {

    public func data(from url: URL) async throws -> (Data, URLResponse) {
        try await data(from: url, delegate: nil)
    }
}
