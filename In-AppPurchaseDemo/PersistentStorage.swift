//
//  PersistentStorage.swift
//  In-AppPurchaseDemo
//
//  Created by Neeshu Kumar on 10/09/24.
//

import Foundation
import StoreKit

struct PersistentStorage {
    static func savePurchaseHistory(_ purchases: [Product]) {
        let productIdentifiers = purchases.map { $0.id }
        UserDefaults.standard.set(productIdentifiers, forKey: "purchaseHistory")
    }
    
    static func loadPurchaseHistory() -> [Product] {
        guard let productIdentifiers = UserDefaults.standard.array(forKey: "purchaseHistory") as? [String] else {
            return []
        }
        // Retrieve products from identifiers (this requires a way to fetch Product instances)
        return productIdentifiers.compactMap { id in
            // Example: Product(id: id)
            return nil // Replace with actual Product fetching logic
        }
    }
    
    static func saveCoinBalance(_ balance: Int) {
        UserDefaults.standard.set(balance, forKey: "coinBalance")
    }
    
    static func loadCoinBalance() -> Int {
        return UserDefaults.standard.integer(forKey: "coinBalance")
    }
    
    static func saveReceiptData(_ data: Data) {
        let keychain = KeychainManager.shared
        keychain.save(key: "receiptData", data: data)
    }
    
    static func loadReceiptData() -> Data? {
        let keychain = KeychainManager.shared
        return keychain.load(key: "receiptData")
    }
}
