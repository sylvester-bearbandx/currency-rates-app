import XCTest
@testable import CurrencyRatesApp

final class PersistenceManagerTests: XCTestCase {
    var persistence: PersistenceManager!

    override func setUp() {
        super.setUp()
        persistence = PersistenceManager()
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
    }

    func testSaveAndLoadFavorites() {
        let rates = [CurrencyRate(code: "USD", rate: 1.1)]
        persistence.saveFavorites(rates)
        let loaded = persistence.loadFavorites()
        XCTAssertEqual(loaded, rates)
    }

    func testSaveAndLoadCachedRates() {
        let rates = [CurrencyRate(code: "EUR", rate: 1.2)]
        persistence.saveCachedRates(rates)
        let loaded = persistence.loadCachedRates()
        XCTAssertEqual(loaded, rates)
    }

    func testSaveAndLoadLastUpdated() {
        let date = Date()
        persistence.saveLastUpdated(date)
        let loaded = persistence.loadLastUpdated()
        XCTAssertEqual(Int(loaded?.timeIntervalSince1970 ?? 0), Int(date.timeIntervalSince1970))
    }
}
