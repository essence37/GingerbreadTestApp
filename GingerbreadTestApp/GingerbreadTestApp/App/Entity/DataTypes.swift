//
//  DataTypes.swift
//  GingerbreadTestApp
//
//  Created by Пазин Даниил on 03.02.2021.
//

import Foundation

struct DataTypes: Codable {
    let url: String?
    let text: String?
    let selectedId: Int?
    let variants: [Variants]?
}
