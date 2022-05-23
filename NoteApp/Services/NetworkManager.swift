//
//  NetworkManager.swift
//  NoteApp
//
//  Created by asbul on 18.05.2022.
//

import Foundation

enum NetworkError: String, Error {
    case invalidURL = "Неверный/недоступный адрес URL"
    case noData = "Нет данных"
    case decodingError = "Ошибка декодирования"
}

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}

    private func createURLComponents() -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "firebasestorage.googleapis.com"
        urlComponents.path = "/v0/b/ios-test-ce687.appspot.com/o/Empty.json"
        urlComponents.queryItems = [
            URLQueryItem(name: "alt", value: "media"),
            URLQueryItem(name: "token", value: "d07f7d4a-141e-4ac5-a2d2-cc936d4e6f18")
        ]
        return urlComponents.url
    }

    func fetchDataWithResult(with completion: @escaping(Result<[NetworkNote], NetworkError>) -> Void) {
        guard let url = createURLComponents() else {
            completion(.failure(.invalidURL))
            return
        }
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else {
                completion(.failure(.noData))
//                print(error?.localizedDescription ?? "No error description")
                return
            }
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .secondsSince1970
                let networkNotes = try decoder.decode([NetworkNote].self, from: data)
//                let networkNotes = try JSONDecoder().decode([NetworkNote].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(networkNotes))
                }
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
}
