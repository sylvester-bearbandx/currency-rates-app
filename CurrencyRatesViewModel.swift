import Foundation

protocol NetworkService {
    func fetchRates(completion: @escaping (Result<([CurrencyRate], Date), Error>) -> Void)
}

class CurrencyRatesViewModel {
    private(set) var rates: [CurrencyRate] = []
    private(set) var favorites: Set<CurrencyRate> = []
    private(set) var isOffline = false
    private(set) var lastUpdated: Date?

    var onDataUpdated: (() -> Void)?

    let persistence: PersistenceManager
    let network: NetworkService

    // Основний ініціалізатор для апки
    init() {
        self.persistence = PersistenceManager()
        self.network = NetworkManager.shared
        self.favorites = Set(persistence.loadFavorites())
        self.lastUpdated = persistence.loadLastUpdated()
    }

    // Спеціальний ініціалізатор для тестів
    init(persistence: PersistenceManager, network: NetworkService) {
        self.persistence = persistence
        self.network = network
        self.favorites = Set(persistence.loadFavorites())
        self.lastUpdated = persistence.loadLastUpdated()
    }

    func fetchRates() {
        network.fetchRates { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }

                switch result {
                case .success(let (rates, date)):
                    self.isOffline = false
                    self.rates = rates
                    self.lastUpdated = date
                    self.persistence.saveCachedRates(rates)
                    self.persistence.saveLastUpdated(date)
                case .failure:
                    self.isOffline = true
                    self.rates = self.persistence.loadCachedRates()
                }
                self.onDataUpdated?()
            }
        }
    }

    func toggleFavorite(_ rate: CurrencyRate) {
        if favorites.contains(rate) {
            favorites.remove(rate)
        } else {
            favorites.insert(rate)
        }
        persistence.saveFavorites(Array(favorites))
        onDataUpdated?()
    }

    func isFavorite(_ rate: CurrencyRate) -> Bool {
        return favorites.contains(rate)
    }
}
