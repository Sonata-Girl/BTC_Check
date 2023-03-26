//
//  RateModel.swift
//  BTC_Check
//
//  Created by Sonata Girl on 25.03.2023.
//

import Foundation

struct RateModel {
    let rate: Double
    
    var rateString: String {
        return String(format: "%.10f", rate)
    }
}
