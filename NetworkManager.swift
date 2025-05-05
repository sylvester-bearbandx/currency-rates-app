import Foundation
class NetworkManager {
    static let shared = NetworkManager()

    private let apiKey = "678fd00ebba2be13876c25de1d48828d5c689968d02452e8e350f36d50af7d5e"
    private let endpoint = "https://swop.cx/graphql"

    func fetchRates(completion: @escaping (Result<([CurrencyRate], Date), Error>) -> Void) {
        guard let url = URL(string: endpoint) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("ApiKey \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let query = [
             "query": """
             {
               latest {
                 baseCurrency
                 quoteCurrency
                 quote
                 date
               }
             }
             """
         ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: query)

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: -1)))
                return
            }

            do {
                let response = try JSONDecoder().decode(SwopResponse.self, from: data)
                let date = ISO8601DateFormatter().date(from: response.data.latest.first?.date ?? "") ?? Date()
                let rates = response.data.latest.map {
                    CurrencyRate(code: $0.quoteCurrency, rate: $0.quote)
                }
                completion(.success((rates, date)))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    private struct SwopResponse: Codable {
        let data: LatestWrapper
    }

    private struct LatestWrapper: Codable {
        let latest: [RateItem]
    }

    private struct RateItem: Codable {
        let baseCurrency: String
        let quoteCurrency: String
        let quote: Double
        let date: String
    }
}
extension NetworkManager: NetworkService {}
