//
//  CoinManager.swift
//  In-AppPurchaseDemo
//
//  Created by Neeshu Kumar on 10/09/24.
//

import Foundation
import StoreKit

class CoinManager {
    private(set) var coins: Int = UserDefaults.standard.integer(forKey: "coinBalance")
    private(set) var coinPurchaseStatus: CoinPurchaseStatus = .idle
    
    func purchaseWithCoins(product: Product) {
        // Convert product price to Int for comparison
        let priceInCoins = convertDecimalToInt(product.price)
        guard coins >= priceInCoins else {
            coinPurchaseStatus = .failure
            return
        }
        
        coins -= priceInCoins
        UserDefaults.standard.set(coins, forKey: "coinBalance")
        coinPurchaseStatus = .success
        // Handle additional purchase logic
    }
    
    func addCoins(amount: Int) {
        coins += amount
        UserDefaults.standard.set(coins, forKey: "coinBalance")
    }
    
    func checkSufficientCoins(for product: Product) -> Bool {
        let priceInCoins = convertDecimalToInt(product.price)
        return coins >= priceInCoins
    }
    
    private func convertDecimalToInt(_ decimal: Decimal) -> Int {
        // Convert Decimal to Int safely
        return NSDecimalNumber(decimal: decimal).intValue
    }
}

enum CoinPurchaseStatus {
    case idle, processing, success, failure
}
