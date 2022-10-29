@testable import FSEconomyDataFeeds
import XCTest
import XMLCoder

final class AircraftFeedsTests: XCTestCase {

    func testAircraftConfigsFeed() throws {
        let feed = Feeds.AircraftConfigsFeed()
        XCTAssertEqual(feed.queryItems, [
            URLQueryItem(name: "query", value: "aircraft"),
            URLQueryItem(name: "search", value: "configs"),
        ])

        let response = try parseResponse(Feeds.AircraftConfigsFeed.self, fromFileNamed: "AircraftConfigData")
        XCTAssertEqual(response.total, 374)
        XCTAssertEqual(response.aircraftConfig, [
            AircraftConfigItems.AircraftConfig(
                makeModel: "Aermacchi - Lockheed AL-60",
                crew: 0,
                seats: 8,
                cruiseSpeed: 218,
                gPH: 35,
                fuelType: 0,
                mTOW: 2051,
                emptyWeight: 1068,
                price: 421050.00,
                ext1: 0,
                ext2: 0,
                lTip: 0,
                lAux: 0,
                lMain: 0,
                center1: 125,
                center2: 0,
                center3: 0,
                rMain: 0,
                rAux: 0,
                rTip: 0,
                engines: 1,
                enginePrice: 44000.00,
                modelId: "95",
                maxCargo: 906
            )
        ])
    }

    func testAircraftAliasesFeed() throws {
        let feed = Feeds.AircraftAliasesFeed()
        XCTAssertEqual(feed.queryItems, [
            URLQueryItem(name: "query", value: "aircraft"),
            URLQueryItem(name: "search", value: "aliases"),
        ])

        let response = try parseResponse(Feeds.AircraftAliasesFeed.self, fromFileNamed: "AircraftAliasData")
        XCTAssertEqual(response.aircraftAliases, [
            AircraftAliasItems.AircraftAliases(
                makeModel: "Aermacchi - Lockheed AL-60",
                alias: [
                    "A320_NEO-United Airlines 8K (A32NX Converted)",
                    "Aermacchi MB326H",
                    "Airbus A330-900neo Corsair",
                ])
        ])
    }

    func testAircraftStatusFeed() throws {
        let feed = Feeds.AircraftStatusFeed(registration: "N12345")
        XCTAssertEqual(feed.queryItems, [
            URLQueryItem(name: "query", value: "aircraft"),
            URLQueryItem(name: "search", value: "status"),
            URLQueryItem(name: "aircraftreg", value: "N12345"),
        ])

        let response = try parseResponse(Feeds.AircraftStatusFeed.self, fromFileNamed: "AircraftStatusData")
        XCTAssertEqual(response.registration, "483514")
        XCTAssertEqual(response.aircraft.serialNumber, "32019")
        XCTAssertEqual(response.aircraft.status, "On Ground")
        XCTAssertEqual(response.aircraft.location, "MT88")
    }

    func testAircraftForSaleFeed() {
        let feed = Feeds.AircraftItemsFeed(.forsale)
        XCTAssertEqual(feed.queryItems, [
            URLQueryItem(name: "query", value: "aircraft"),
            URLQueryItem(name: "search", value: "forsale"),
        ])
    }

    func testAircraftMakeModelFeed() {
        let feed = Feeds.AircraftItemsFeed(.makeModel("Cessna 172 Skyhawk"))
        XCTAssertEqual(feed.queryItems, [
            URLQueryItem(name: "query", value: "aircraft"),
            URLQueryItem(name: "search", value: "makemodel"),
            URLQueryItem(name: "makemodel", value: "Cessna 172 Skyhawk"),
        ])
    }

    func testAircraftOwnerNameFeed() {
        let feed = Feeds.AircraftItemsFeed(.ownerName("johndoe123"))
        XCTAssertEqual(feed.queryItems, [
            URLQueryItem(name: "query", value: "aircraft"),
            URLQueryItem(name: "search", value: "ownername"),
            URLQueryItem(name: "ownername", value: "johndoe123"),
        ])
    }

    func testAircraftRegistrationFeed() {
        let feed = Feeds.AircraftItemsFeed(.registration("N12345"))
        XCTAssertEqual(feed.queryItems, [
            URLQueryItem(name: "query", value: "aircraft"),
            URLQueryItem(name: "search", value: "registration"),
            URLQueryItem(name: "aircraftreg", value: "N12345"),
        ])
    }

    func testAircraftSerialNumberFeed() {
        let feed = Feeds.AircraftItemsFeed(.serialNumber("12345"))
        XCTAssertEqual(feed.queryItems, [
            URLQueryItem(name: "query", value: "aircraft"),
            URLQueryItem(name: "search", value: "serialnumber"),
            URLQueryItem(name: "serialnumber", value: "12345"),
        ])
    }

    func testAircraftKeyFeed() {
        let feed = Feeds.AircraftItemsFeed(.key("ABC123"))
        XCTAssertEqual(feed.queryItems, [
            URLQueryItem(name: "query", value: "aircraft"),
            URLQueryItem(name: "search", value: "key"),
            URLQueryItem(name: "readaccesskey", value: "ABC123"),
        ])
    }

    func testAircraftICAOFeed() {
        let feed = Feeds.AircraftItemsFeed(.icao("CZFA"))
        XCTAssertEqual(feed.queryItems, [
            URLQueryItem(name: "query", value: "icao"),
            URLQueryItem(name: "search", value: "aircraft"),
            URLQueryItem(name: "icao", value: "CZFA"),
        ])
    }

    func testAircraftItemsFeedParsing() throws {
        let response = try parseResponse(Feeds.AircraftItemsFeed.self, fromFileNamed: "AircraftItemsData")
        XCTAssertEqual(response.total, 5)
        XCTAssertEqual(response.query, "TestQuery")
        XCTAssertEqual(response.aircraft.count, 5)
        XCTAssertEqual(response.aircraft.first, AircraftItems.Aircraft(
            serialNumber: "14591",
            makeModel: "Cessna 182 Skylane",
            registration: "C-FDUW",
            owner: "Bank of FSE",
            location: "CZFA",
            locationName: "Faro, Faro, Yukon Territory, Canada",
            home: "CYQG",
            salePrice: 0.0,
            sellbackPrice: 129934,
            equipment: .init("IFR/AP/GPS"),
            rentalDry: 145,
            rentalWet: 209,
            rentalType: .hour,
            bonus: 45,
            rentalTime: 25200,
            rentedBy: "Not rented.",
            fuelPct: 0.09,
            needsRepair: false,
            airframeTime: "102:01",
            engineTime: "102:01",
            timeLast100hr: "17:57",
            leasedFrom: "NA",
            monthlyFee: 1299,
            feeOwed: 0
        ))
    }
}
