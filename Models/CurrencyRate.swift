struct CurrencyRate: Codable, Hashable {
    let code: String
    let rate: Double

    func hash(into hasher: inout Hasher) {
        hasher.combine(code)
    }

    static func == (lhs: CurrencyRate, rhs: CurrencyRate) -> Bool {
        return lhs.code == rhs.code
    }
}
