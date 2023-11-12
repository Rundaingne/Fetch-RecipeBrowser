//
//  URLService.swift
//  Fetch-RecipeBrowser
//
//  Created by Erich Kumpunen on 11/10/23.
//

import Foundation

enum Endpoints: String {
    case recipes = "https://themealdb.com/api/json/v1/1/filter.php"
    case details = "https://themealdb.com/api/json/v1/1/lookup.php"
}

struct URLService {
    /// Generic function for obtaining endpoint data using base URLs. If it requires a query or other addage, handle it inside with if/switch statements.
    static func getData<T>(from endpoint: Endpoints, with id: String? = nil, and category: MealCategory = .dessert) async throws -> T where T: Decodable {
        do {
            let url = URL(string: endpoint.rawValue)
            var realURL = url
            if let id = id {
                let queryItem = URLQueryItem(name: "i", value: id)
                realURL = url?.appending(queryItems: [queryItem])
            } else {
                let queryItem = URLQueryItem(name: "c", value: category.rawValue)
                realURL = url?.appending(queryItems: [queryItem])
            }
            print("Real url is: \(String(describing: realURL))")
            
            var request = URLRequest(url: realURL!)
            request.timeoutInterval = 5
            let rData = try await URLSession.shared.data(for: request)
            let response = try JSONDecoder().decode(T.self, from: rData.0)
            return response
        } catch {
            throw error
        }
    }
}
