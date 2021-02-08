//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet var currencyLabelCost: UILabel!
    @IBOutlet var currencyLabel: UILabel!
    @IBOutlet var coinLabelImage: UIImageView!
    @IBOutlet var currencyPicker: UIPickerView!
    
    var coinManager: CoinManager = CoinManager()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        coinManager.delegate = self
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
    }
}

//Mark: - CoinManagerDelegate
extension ViewController: CoinManagerDelegate {
    func didUpdatePrice(price priceString: String, currency: String) {
        DispatchQueue.main.async {
            self.currencyLabelCost.text = priceString
            self.currencyLabel.text = currency
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//Mark: - Picker
extension ViewController {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    //This function is called everytime the user scrolls the picker
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let coinSelected: String = coinManager.currencyArray[row]
        coinManager.getCoinPrice(for: coinSelected)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
}
