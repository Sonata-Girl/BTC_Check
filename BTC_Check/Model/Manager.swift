//
//  BTCManager.swift
//  BTC_Check
//
//  Created by Sonata Girl on 25.03.2023.
//

import Foundation

protocol ManagerDelegate {
    func didUpdateRate(_ managerDelegate: Manager, rate: String)
    func didFailWithError(error: Error)
}

struct Manager {
    //    "https://rest.coinapi.io/v1/exchangerate/BTC/USD"
    let url = "https://rest.coinapi.io/v1/exchangerate"
    let apiKeyString = "apikey=14119528-2D59-46CC-A8B3-7B07747736B6"
    
    var delegate: ManagerDelegate?
    
    func getRate(fromCurrency: String, toCurrency: String) {
        let urlString = "\(url)/\(fromCurrency.localizedUppercase)/\(toCurrency.localizedUppercase)?\(apiKeyString)"
        sendRequest(urlString: urlString)
    }
    
    func sendRequest(urlString: String) {        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, responce, error) in
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let rate = self.parseJSON(safeData) {
                        delegate?.didUpdateRate(self, rate: rate)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ rateData: Data) -> String? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(ApiData.self, from: rateData)
            let rate = RateModel(rate: decodedData.rate)
            
            return rate.rateString
        } catch {
            return nil
        }
    }
}
