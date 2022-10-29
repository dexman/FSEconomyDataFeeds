import Foundation

extension Feeds {

    /// Aircraft Configs
    public struct AircraftConfigsFeed: Feed {
        public typealias ResponseType = AircraftConfigItems

        public init() {}

        public var queryItems: [URLQueryItem] {
            [
                URLQueryItem(name: "query", value: "aircraft"),
                URLQueryItem(name: "search", value: "configs"),
            ]
        }
    }

    /// Aircraft Aliases
    public struct AircraftAliasesFeed: Feed {
        public typealias ResponseType = AircraftAliasItems

        public init() {}

        public var queryItems: [URLQueryItem] {
            [
                URLQueryItem(name: "query", value: "aircraft"),
                URLQueryItem(name: "search", value: "aliases"),
            ]
        }
    }

    /// Aircraft Status By Registration
    public struct AircraftStatusFeed: Feed {
        public typealias ResponseType = AircraftStatus

        public let registration: String

        public init(registration: String) {
            self.registration = registration
        }

        public var queryItems: [URLQueryItem] {
            [
                URLQueryItem(name: "query", value: "aircraft"),
                URLQueryItem(name: "search", value: "status"),
                URLQueryItem(name: "aircraftreg", value: registration),
            ]
        }
    }

    /// Aircraft Items Feeds
    public struct AircraftItemsFeed: Feed {
        public enum QueryType {
            case forsale
            case makeModel(String)
            case ownerName(String)
            case registration(String)
            case serialNumber(AircraftSerialNumber)
            case key(String)
            case icao(ICAO)
        }

        public typealias ResponseType = AircraftItems

        public let queryType: QueryType

        public init(_ queryType: QueryType) {
            self.queryType = queryType
        }

        public var queryItems: [URLQueryItem] {
            var result = [
                URLQueryItem(name: "query", value: queryValue),
                URLQueryItem(name: "search", value: searchValue),
            ]
            if let queryItem = queryItem {
                result.append(queryItem)
            }
            return result
        }

        private var queryValue: String {
            switch queryType {
            case .forsale,
                    .makeModel,
                    .ownerName,
                    .registration,
                    .serialNumber,
                    .key:
                return "aircraft"
            case .icao:
                return "icao"
            }
        }

        private var searchValue: String {
            switch queryType {
            case .forsale:
                return "forsale"
            case .makeModel:
                return "makemodel"
            case .ownerName:
                return "ownername"
            case .registration:
                return "registration"
            case .serialNumber:
                return "serialnumber"
            case .key:
                return "key"
            case .icao:
                return "aircraft"
            }
        }

        private var queryItem: URLQueryItem? {
            switch queryType {
            case .forsale:
                return nil
            case .makeModel(let makeModel):
                return URLQueryItem(name: "makemodel", value: makeModel)
            case .ownerName(let ownerName):
                return URLQueryItem(name: "ownername", value: ownerName)
            case .registration(let registration):
                return URLQueryItem(name: "aircraftreg", value: registration)
            case .serialNumber(let serialNumber):
                return URLQueryItem(name: "serialnumber", value: serialNumber.value)
            case .key(let key):
                return URLQueryItem(name: "readaccesskey", value: key)
            case .icao(let icao):
                return URLQueryItem(name: "icao", value: icao.value)
            }
        }
    }
}

public struct AircraftSerialNumber: CustomDebugStringConvertible, Decodable, Equatable, ExpressibleByStringLiteral  {

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

public struct AircraftItems: Decodable, Equatable {
    public struct Aircraft: Decodable, Equatable {
        public struct Equipment: CustomDebugStringConvertible, Decodable, Equatable  {

            public let value: String

            public init(_ value: String) {
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

        public enum RentalType: String, CustomDebugStringConvertible, Decodable, Equatable {
            case hour

            public var debugDescription: String {
                rawValue
            }
        }

        public let serialNumber: AircraftSerialNumber
        public let makeModel: String
        public let registration: String
        public let owner: String
        public let location: ICAO
        public let locationName: String
        public let home: ICAO
        public let salePrice: Decimal
        public let sellbackPrice: Decimal
        public let equipment: Equipment
        public let rentalDry: Decimal
        public let rentalWet: Decimal
        public let rentalType: RentalType
        public let bonus: Decimal
        public let rentalTime: Int
        public let rentedBy: String // or "Not rented."
        public let fuelPct: Float // [0.0, 1.0]
        public let needsRepair: Bool
        public let airframeTime: String // 271:06
        public let engineTime: String // 271:06
        public let timeLast100hr: String // 271:06
        public let leasedFrom: String // or "NA"
        public let monthlyFee: Decimal
        public let feeOwed: Decimal
    }

    public let query: String
    public let total: Int
    public let aircraft: [Aircraft]
}

public struct AircraftConfigItems: Decodable, Equatable {
    public struct AircraftConfig: Decodable, Equatable {
        public let makeModel: String
        public let crew: Int
        public let seats: Int
        public let cruiseSpeed: Int
        public let gPH: Int
        public let fuelType: Int
        public let mTOW: Int
        public let emptyWeight: Int
        public let price: Decimal
        public let ext1: Int
        public let ext2: Int
        public let lTip: Int
        public let lAux: Int
        public let lMain: Int
        public let center1: Int
        public let center2: Int
        public let center3: Int
        public let rMain: Int
        public let rAux: Int
        public let rTip: Int
        public let engines: Int
        public let enginePrice: Decimal
        public let modelId: String
        public let maxCargo: Int
    }

    public let total: Int
    public let aircraftConfig: [AircraftConfig]
}

public struct AircraftAliasItems: Decodable, Equatable {
    public struct AircraftAliases: Decodable, Equatable {
        public let makeModel: String
        public let alias: [String]
    }

    public let aircraftAliases: [AircraftAliases]
}

public struct AircraftStatus: Decodable, Equatable {
    public struct Aircraft: Decodable, Equatable {
        public let serialNumber: AircraftSerialNumber // 32019
        public let status: String // "On Ground"
        public let location: ICAO // MT88
    }

    public let registration: String
    public let aircraft: Aircraft
}
