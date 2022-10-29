import Foundation

public struct ICAO: Codable, CustomDebugStringConvertible, Equatable, ExpressibleByStringLiteral  {

    public let value: String

    public init(_ value: String) {
        self.value = value
    }

    public init(stringLiteral value: StringLiteralType) {
        self.value = value
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.value = try container.decode(String.self)
    }

    public var debugDescription: String {
        return value
    }
}
