import Foundation

extension Feeds {

    /// ICAO Jobs To / From
    public struct ICAOJobsFeed: Feed {
        public enum JobType {
            case to
            case from
        }

        public typealias ResponseType = ICAOJobs

        public let jobType: JobType
        public let icaos: [ICAO]

        public init(_ jobType: JobType, icaos: ICAO...) {
            self.jobType = jobType
            self.icaos = icaos
        }

        public init(_ jobType: JobType, icaos: [ICAO]) {
            self.jobType = jobType
            self.icaos = icaos
        }

        public var queryItems: [URLQueryItem] {
            [
                URLQueryItem(name: "query", value: "icao"),
                URLQueryItem(name: "search", value: searchString),
                URLQueryItem(name: "icaos", value: icaosString),
            ]
        }

        private var searchString: String {
            switch jobType {
            case .to:
                return "jobsto"
            case .from:
                return "jobsfrom"
            }
        }

        private var icaosString: String {
            icaos.map(\.value).joined(separator: "-")
        }
    }
}

public struct ICAOJobs: Decodable, Equatable {
    public struct Assignment: Decodable, Equatable {
        public enum UnitType: String, Decodable, Equatable {
            case kg
            case passengers
        }

        public enum AssignmentType: String, Decodable, Equatable {
            case allIn = "All-In"
            case tripOnly = "Trip-Only"
            case vip = "VIP"
        }

        public let id: String
        public let location: ICAO
        public let toIcao: ICAO
        public let fromIcao: ICAO
        public let amount: Int
        public let unitType: UnitType
        public let commodity: String
        public let pay: Decimal
        public let expires: String
        public let expireDateTime: Date
        public let express: Bool
        public let ptAssignment: Bool
        public let type: AssignmentType
        public let aircraftId: String
    }

    public let total: Int
    public let assignment: [Assignment]
}
