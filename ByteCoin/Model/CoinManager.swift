//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdatePrice(price: String, currency: String)
    func didFailWithError(error: Error)
}


struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "Insert your key here"
    
    let crytoCurrency = ["BTC", "ETH"]
    
    let currencyArray = ["EUR", "BRL","CAD","CNY","AUD","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPrice(for currency: String)  {
        let finalUrl = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        //Creo l'url
        if let url = URL(string: finalUrl) {
            //Creo la sessione
            let session = URLSession(configuration: .default)
            //Creo il task
            let task = session.dataTask(with: url) { (data, response, error)  in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    //Parse the data
                    if let bicoinPrice = self.parseJSON(safeData) {
                        let priceString: String = String(format: "%0.3f", bicoinPrice)
                        self.delegate?.didUpdatePrice(price: priceString, currency: currency)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> Double? {
            
            //Create a JSONDecoder
            let decoder = JSONDecoder()
            do {
                
                //try to decode the data using the CoinData structure
                let decodedData = try decoder.decode(CoinData.self, from: data)
                //Get the last property from the decoded data.
                let lastPrice = decodedData.rate
                return lastPrice
            } catch {
                
                //Catch and print any errors.
                self.delegate?.didFailWithError(error: error)
                return nil
            }
        }
}
