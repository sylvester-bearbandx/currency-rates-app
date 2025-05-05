import XCTest
@testable import CurrencyRatesApp

final class CurrencyRatesViewModelTests: XCTestCase {

    var viewModel: CurrencyRatesViewModel!
    var persistence: PersistenceManagerMock!
    var network: NetworkManagerMock!

    override func setUp() {
        super.setUp()
        persistence = PersistenceManagerMock()
        network = NetworkManagerMock()
        viewModel = CurrencyRatesViewModel(persistence: persistence, network: network)
    }

    func testInitialFavoritesEmpty() {
        XCTAssertTrue(viewModel.favorites.isEmpty)
    }

    func testToggleFavorite_AddsAndRemoves() {
        let rate = CurrencyRate(code: "USD", rate: 1.0)

        viewModel.toggleFavorite(rate)
        XCTAssertTrue(viewModel.favorites.contains(rate))

        viewModel.toggleFavorite(rate)
        XCTAssertFalse(viewModel.favorites.contains(rate))
    }

    func testIsFavorite_ReturnsTrueForFavorite() {
        let rate = CurrencyRate(code: "EUR", rate: 1.0)
        viewModel.toggleFavorite(rate)
        XCTAssertTrue(viewModel.isFavorite(rate))
    }

    func testFallbackToCachedRates_WhenOffline() {
        let cached = [CurrencyRate(code: "UAH", rate: 40.0)]
        persistence.cachedRates = cached

        let expectation = XCTestExpectation(description: "Wait for async fetch")

        viewModel.onDataUpdated = {
            XCTAssertEqual(self.viewModel.rates, cached)
            XCTAssertTrue(self.viewModel.isOffline)
            expectation.fulfill()
        }

        viewModel.fetchRates()
        wait(for: [expectation], timeout: 2)
    }
}

// MARK: - Моки

class PersistenceManagerMock: PersistenceManager {
    var cachedRates: [CurrencyRate] = []
    var favoritesMock: [CurrencyRate] = []
    var savedLastUpdated: Date? = nil

    override func saveFavorites(_ favorites: [CurrencyRate]) {
        favoritesMock = favorites
    }

    override func loadFavorites() -> [CurrencyRate] {
        return favoritesMock
    }

    override func saveCachedRates(_ rates: [CurrencyRate]) {
        cachedRates = rates
    }

    override func loadCachedRates() -> [CurrencyRate] {
        return cachedRates
    }

    override func saveLastUpdated(_ date: Date) {
        savedLastUpdated = date
    }

    override func loadLastUpdated() -> Date? {
        return savedLastUpdated
    }
}

class NetworkManagerMock: NetworkService {
    func fetchRates(completion: @escaping (Result<([CurrencyRate], Date), Error>) -> Void) {
        completion(.failure(NSError(domain: "offline", code: -1009, userInfo: nil)))
    }
}
