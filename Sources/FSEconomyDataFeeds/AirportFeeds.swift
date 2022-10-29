import Foundation

extension Feeds {

    public struct AirportsFeed: Feed {
        public typealias ResponseType = [Airport]

        public init() {}

        public let queryItems: [URLQueryItem] = []
    }
}

public struct Airport: Codable, Equatable {
    public enum AirportType: String, Codable {
        case civil
        case military
        case water
    }

    public let icao: ICAO
    public let lat: Double
    public let lon: Double
    public let type: AirportType
    public let size: Int
    public let name: String
    public let city: String
    public let state: String?
    public let country: String
}
