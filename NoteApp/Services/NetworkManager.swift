import Foundation

enum NetworkError: Error {
    case invalidMissingURL
    case noData
    case decodingError
}

final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}

    private func createURLComponents() -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "firebasestorage.googleapis.com"
        urlComponents.path = "/v0/b/ios-test-ce687.appspot.com/o/lesson8.json"
        urlComponents.queryItems = [
            URLQueryItem(name: "alt", value: "media"),
            URLQueryItem(name: "token", value: "215055df-172d-4b98-95a0-b353caca1424")
        ]
        return urlComponents.url
    }

    func fetchNotes(
        successCompletion: @escaping (([NetworkNote]) -> Void),
        failureCompletion: @escaping ((NetworkError) -> Void)
    ) {
        guard let url = createURLComponents() else {
            failureCompletion(.invalidMissingURL)
            return
        }
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else {
                failureCompletion(.noData)
                return
            }
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .secondsSince1970
                let networkNotes = try decoder.decode([NetworkNote].self, from: data)
                let delay = DispatchTime.now() + .seconds(1)
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    successCompletion(networkNotes)
                }
            } catch {
                failureCompletion(.decodingError)
            }
        }.resume()
    }
}
