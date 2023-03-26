//
//  ApiData.swift
//  BTC_Check
//
//  Created by Sonata Girl on 25.03.2023.
//

import Foundation

struct ApiData: Codable {
    let time: String
    let asset_id_base: String
    let asset_id_quote: String
    let rate: Double
}
