//
//  NetworkError.swift
//  pw_exam
//
//  Created by Антон Лисицын on 03.04.2026.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case decoding(Error)
    case server(Int)
}
