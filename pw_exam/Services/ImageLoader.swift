//
//  ImageLoader.swift
//  pw_exam
//
//  Created by Антон Лисицын on 03.04.2026.
//

import UIKit

final class ImageLoader {
    
    static let shared = ImageLoader()
    
    private let cache = NSCache<NSURL, UIImage>()
    
    func load(_ url: URL) async throws -> UIImage {
        
        if let cached = cache.object(forKey: url as NSURL) {
            return cached
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        guard let image = UIImage(data: data) else {
            throw URLError(.badServerResponse)
        }
        
        cache.setObject(image, forKey: url as NSURL)
        
        return image
    }
}
