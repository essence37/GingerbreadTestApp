//
//  ErrorNetwork.swift
//  GingerbreadTestApp
//
//  Created by Пазин Даниил on 03.02.2021.
//

import Foundation

enum ErrorNetwork: LocalizedError {
    case unreachableAddress(_ url: URL)
    case invalidResponse

    var errorDescription: String? {
        switch self {
        case .unreachableAddress(let url): return "\(url) is unreachable"
        case .invalidResponse: return "Response with mistake"
        }
    }
}
