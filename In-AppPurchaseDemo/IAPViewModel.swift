//
//  IAPViewModel.swift
//  In-AppPurchaseDemo
//
//  Created by Neeshu Kumar on 10/09/24.
//

import StoreKit
import Combine
import SwiftUI

protocol IAPViewModelProtocol: ObservableObject {
    var availableProducts: [Product] { get set }
    var purchasedProducts: Set<Product> { get set }
    var purchaseStatus: PurchaseStatus { get set }
    var errorMessage: String? { get set }
    var currentCoins: Int { get set }
    var currentSubscription: Subscription? { get set }
    var subscriptionUpgradeOptions: [SubscriptionUpgradeOption] { get set }
    var isReceiptValid: Bool { get set }
    var isNetworkAvailable: Bool { get set }
    var currentSelectedProduct: Product? { get set }
    
    func loadProducts()
    func purchaseProduct(product: Product)
    func restorePurchases()
    func validateReceipt()
    func handleUpgrade(downgrade: Bool)
    func deductCoinsForPurchase(product: Product)
}

class IAPViewModel: IAPViewModelProtocol {
    @Published var availableProducts: [Product] = []
    @Published var purchasedProducts: Set<Product> = []
    @Published var purchaseStatus: PurchaseStatus = .idle
    @Published var errorMessage: String?
    @Published var currentCoins: Int = 0
    @Published var currentSubscription: Subscription?
    @Published var subscriptionUpgradeOptions: [SubscriptionUpgradeOption] = []
    @Published var isReceiptValid: Bool = false
    @Published var isNetworkAvailable: Bool = true
    @Published var currentSelectedProduct : Product?
    @Published var isSingleTemplateSelectedOrNot : Bool = false
    var consumableImage : Image?
    
    private var cancellables = Set<AnyCancellable>()
    private let networkManager = NetworkManager()
    private let coinManager = CoinManager()
    
    let singleTemplateProduct = IAPProduct(productIdentifier: "com.irisstudio.watermarkpro.monthly", localizedTitleSuffix: "", freeTrialDays: 7, features: ["No Watermark", "Unlock Single Template"], oldUserDefaultKeyIfAny: "", cellImage: Image("p1"), title: "Single", subTitle: "Only One Template", isHighlighted: false, status: "", tag: "/ Only One")
    
    let monthlyTemplateProduct =  IAPProduct(productIdentifier: "com.irisstudio.watermarkpro.monthly", localizedTitleSuffix: "", freeTrialDays: 7, features: ["No Ads - No Watermark", "All Premium Content"], oldUserDefaultKeyIfAny: "", cellImage: Image("p2"), title: "Monthly", subTitle: "Full Access Subscription", isHighlighted: false, status: "Most Popular", tag: "/ Monthly")
    
    let yearlyTemplateProduct =  IAPProduct(productIdentifier: "com.irisstudio.watermarkpro.monthly", localizedTitleSuffix: "", freeTrialDays: 7, features: ["No Ads - No Watermark", "All Premium Content"], oldUserDefaultKeyIfAny: "", cellImage: Image("p2"), title: "Yearly", subTitle: "Full Access Subscription", isHighlighted: true, status: "Save 80%", tag: "/ Yearly")
    
    init(isSingleTemplateSelectedOrNot : Bool , image : Image = Image(systemName: "p1")) {
        self.consumableImage = image
        singleTemplateProduct.cellImage = image
        self.isSingleTemplateSelectedOrNot = isSingleTemplateSelectedOrNot
        loadProducts()
    }
  
    func loadProducts() {
        Task {
            do {
//                let productIDs = ["com.irisstudio.watermarkPre.pro", "com.irisstudio.watermarkpro.monthly", "com.irisstudio.watermarkpro.yearly"]
                let productIDs = ["Monthly", "Yearly", "singleTemplate"]
                let products = try await Product.products(for: productIDs)
                DispatchQueue.main.async {
                    self.availableProducts = products
                }
                          
                
                for await result in Transaction.currentEntitlements {
                    switch result {
                    case .verified(let transaction):
                        if let product = products.first(where: { $0.id == transaction.productID }) {
                            DispatchQueue.main.async {
                                self.purchasedProducts.insert(product)
                            }
                        }
                    case .unverified(_, _):
                        break
                    }
                }
                
                for product in products {
                    let isPurchased = purchasedProducts.contains(product)
                    print("Product ID: \(product.id), Purchased: \(isPurchased), Type: \(product.type)")
                    
                    if isPurchased {
                        print("This product has been purchased.")
                    } else {
                        print("This product has not been purchased.")
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to load products."
                }
            }
        }
    }
    
    func purchaseProduct(product: Product) {
        DispatchQueue.main.async {
            self.purchaseStatus = .processing
        }
        Task {
            do {
                let result = try await product.purchase()
                await handlePurchaseVerification(result)
            } catch {
                DispatchQueue.main.async {
                    self.purchaseStatus = .failure
                    self.errorMessage = "Purchase failed: \(error.localizedDescription)"
                }
            }
        }
    }

    private func handlePurchaseVerification(_ result: Product.PurchaseResult) async {
        switch result {
        case .success(let verification):
            switch verification {
            case .verified(let transaction):
                if let product = availableProducts.first(where: { $0.id == transaction.productID }) {
                    purchasedProducts.insert(product)
                }
                await transaction.finish()
                purchaseStatus = .success
            case .unverified(_, let error):
                purchaseStatus = .failure
                errorMessage = "Unverified transaction: \(error.localizedDescription)"
            }
        case .pending:
            purchaseStatus = .processing
        case .userCancelled:
            print("User Cancelled")
        @unknown default:
            print("")
        }
    }
    
    func restorePurchases() {
        DispatchQueue.main.async {
            self.purchaseStatus = .processing
        }
        Task {
            do {
                for await result in Transaction.currentEntitlements {
                    switch result {
                    case .verified(let transaction):
                        if let product = availableProducts.first(where: { $0.id == transaction.productID }) {
                            DispatchQueue.main.async {
                                self.purchasedProducts.insert(product)
                            }
                        }
                    case .unverified(_, _):
                        break
                    }
                }
                DispatchQueue.main.async {
                    self.purchaseStatus = .success
                }
            } catch {
                DispatchQueue.main.async {
                    self.purchaseStatus = .failure
                    self.errorMessage = "Failed to restore purchases: \(error.localizedDescription)"
                }
            }
        }
    }
    
    func validateReceipt() {
        Task {
            do {
                let receiptData = try await fetchReceiptData()
                networkManager.validateReceipt(receiptData: receiptData) { [weak self] result in
                    switch result {
                    case .success(let validationResult):
                        self?.isReceiptValid = validationResult.isValid
                    case .failure(let error):
                        self?.errorMessage = "Receipt validation failed: \(error.localizedDescription)"
                    }
                }
            } catch {
                errorMessage = "Failed to get receipt data: \(error.localizedDescription)"
            }
        }
    }
    
    private func fetchReceiptData() async throws -> Data {
        guard let receiptURL = Bundle.main.appStoreReceiptURL,
              let receiptData = try? Data(contentsOf: receiptURL) else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Receipt not found"])
        }
        return receiptData
    }
    
    func handleUpgrade(downgrade: Bool) {
        guard let currentSubscription = currentSubscription else {
            errorMessage = "No current subscription found."
            return
        }
        
        let newSubscriptionID = downgrade ? "com.example.app.downgrade" : "com.example.app.upgrade"
        
        Task {
            do {
                if let newProduct = try await Product.products(for: [newSubscriptionID]).first {
                    let result = try await newProduct.purchase()
                    await handlePurchaseVerification(result, isDowngrade: downgrade)
                } else {
                    errorMessage = "New subscription product not found."
                }
            } catch {
                errorMessage = "Upgrade failed: \(error.localizedDescription)"
            }
        }
    }
    
    private func handlePurchaseVerification(_ result: Product.PurchaseResult, isDowngrade: Bool) async {
        switch result {
        case .success(let verification):
            switch verification {
            case .verified(let transaction):
                if isDowngrade {
                    // Handle downgrade logic
                } else {
                    // Handle upgrade logic
                }
                await transaction.finish()
                purchaseStatus = .success
            case .unverified(_, let error):
                purchaseStatus = .failure
                errorMessage = "Unverified transaction: \(error.localizedDescription)"
            }
        case .pending:
            purchaseStatus = .processing
        case .userCancelled:
            print("User Cancelled")
        @unknown default:
            print("Unknown case encountered.")
        }
    }
    
    func deductCoinsForPurchase(product: Product) {
        if coinManager.checkSufficientCoins(for: product) {
            coinManager.purchaseWithCoins(product: product)
        } else {
            errorMessage = "Insufficient coins."
        }
    }
}

enum PurchaseStatus {
    case idle, processing, success, failure
}

struct Subscription {}
struct SubscriptionUpgradeOption {}
