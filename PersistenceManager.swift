import Foundation
class PersistenceManager {
    private let favoritesKey = "favorites"
    private let cachedRatesKey = "cachedRates"
    private let lastUpdatedKey = "lastUpdated"

    func saveFavorites(_ favorites: [CurrencyRate]) {
        let data = try? JSONEncoder().encode(favorites)
        UserDefaults.standard.set(data, forKey: favoritesKey)
    }

    func loadFavorites() -> [CurrencyRate] {
        guard let data = UserDefaults.standard.data(forKey: favoritesKey),
              let favorites = try? JSONDecoder().decode([CurrencyRate].self, from: data) else { return [] }
        return favorites
    }

    func saveCachedRates(_ rates: [CurrencyRate]) {
        let data = try? JSONEncoder().encode(rates)
        UserDefaults.standard.set(data, forKey: cachedRatesKey)
    }

    func loadCachedRates() -> [CurrencyRate] {
        guard let data = UserDefaults.standard.data(forKey: cachedRatesKey),
              let cached = try? JSONDecoder().decode([CurrencyRate].self, from: data) else { return [] }
        return cached
    }

    func saveLastUpdated(_ date: Date) {
        UserDefaults.standard.set(date.timeIntervalSince1970, forKey: lastUpdatedKey)
    }

    func loadLastUpdated() -> Date? {
        let timestamp = UserDefaults.standard.double(forKey: lastUpdatedKey)
        return timestamp > 0 ? Date(timeIntervalSince1970: timestamp) : nil
    }
}
