import XCTest
@testable import CurrencyRatesApp

final class FavoritesLogicTests: XCTestCase {
    func testFavoritesListMatchesToggleState() {
        let viewModel = CurrencyRatesViewModel()
        let rate = CurrencyRate(code: "GBP", rate: 1.3)
        viewModel.toggleFavorite(rate)

        XCTAssertTrue(viewModel.favorites.contains(rate))
        XCTAssertTrue(viewModel.isFavorite(rate))
    }
}
