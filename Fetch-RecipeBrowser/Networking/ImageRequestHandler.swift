//
//  ImageRequestHandler.swift
//  Fetch-RecipeBrowser
//
//  Created by Erich Kumpunen on 11/11/23.
//

import UIKit

typealias Paramaters = [String: String]

struct ImageRequestHandler {
    
    /// Normally, for images being loaded from a database like S3, there would be a multipart request handler, or use of AlamoFire, to ensure the large files can download more efficiently. But I would need to know more details for that, so for now it's just a regular http get request. This will result in slower load times on occasion.
    /// Also note that the images are not being fetched in a scalable manner -- all at once. Use of pagination on the recipe requests would solve this, but not needed for this level of scope.

    static let shared = ImageRequestHandler()
    private init() {}
        
    func getRequest(url: String) async -> UIImage? {
        guard let url = URL(string: url) else { return nil }
        
        var image: UIImage?
        let request = URLRequest(url: url)
        
        do {
            let data = try await URLSession.shared.data(for: request)
            image = UIImage(data: data.0)
            return image
        } catch {
            print("Error fetching image: \(error), \(error.localizedDescription)")
            return nil
        }
    }
}
