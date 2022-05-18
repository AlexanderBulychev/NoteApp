//
//  NetworkManager.swift
//  NoteApp
//
//  Created by asbul on 18.05.2022.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

class Worker {
    static let shared = Worker()
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

    func fetchDataWithResult(with completion: @escaping(Result<[NetworkNotes], NetworkError>) -> Void) {
        guard let url = createURLComponents() else {
            completion(.failure(.invalidURL))
            return
        }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                completion(.failure(.noData))
                print(error?.localizedDescription ?? "No error description")
                return
            }
            do {
                let networkNotes = try JSONDecoder().decode([NetworkNotes].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(networkNotes))
                }
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
}
