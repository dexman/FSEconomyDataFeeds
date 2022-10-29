import Foundation

public protocol Feed {
    associatedtype ResponseType: Decodable

    var queryItems: [URLQueryItem] { get }
}

public enum Feeds {}
