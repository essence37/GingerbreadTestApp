//
//  APIClient.swift
//  GingerbreadTestApp
//
//  Created by Пазин Даниил on 03.02.2021.
//

import Foundation
import Combine

struct APIClient {
    private let url = URL(string: "https://pryaniky.com/static/json/sample.json")!
    private let queue = DispatchQueue(label: "APIClient", qos: .default, attributes: .concurrent)
    
    func getSample() -> AnyPublisher<Sample, ErrorNetwork> {
        return URLSession.shared
            .dataTaskPublisher(for: url)
            .receive(on: queue)
            .map(\.data)
            .decode(type: Sample.self, decoder: JSONDecoder())
            .mapError({ error -> ErrorNetwork in
                switch error {
                case is URLError:
                    return ErrorNetwork.unreachableAddress(url)
                default:
                    return ErrorNetwork.invalidResponse
                }
            })
            .eraseToAnyPublisher()
    }
}
