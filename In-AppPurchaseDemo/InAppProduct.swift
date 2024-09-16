//
//  InAppProduct.swift
//  In-AppPurchaseDemo
//
//  Created by Neeshu Kumar on 11/09/24.
//

import Foundation
import StoreKit
import SwiftUI

public enum IAPProductType {
    case autoRenewable
    case oneTime
    case unknown
}

public enum IAPProductLife {
    case monthly
    case yearly
    case daily
    case weekly
    case lifetime
    case unknown
    
    public func description() -> String {
        switch self {
        case .monthly:
            return "Monthly"
        case .yearly:
            return "Yearly"
        case .daily:
            return "Daily"
        case .weekly:
            return "Weekly"
        case .lifetime:
            return "Lifetime"
        case .unknown:
            return "Unknown"
        }
    }
}

public class IAPProduct {
    public var productIdentifier: String
    public var localizedTitleSuffix: String
    public var freeTrialDays: Int
    public var features: [String]
    public var oldUserDefaultKeyIfAny: String?
    public var cellImage : Image?
    public var backgroundImage : Any?
    public var title: String
    public var subtitle: String
    public var price: String?  // Use @Published for optional string
    public var tag: String
    public var isHighlighted: Bool
    public var status: String
    

    public init(productIdentifier: String, localizedTitleSuffix: String, freeTrialDays: Int, features: [String], oldUserDefaultKeyIfAny: String?, cellImage : Image, title : String , subTitle : String, isHighlighted : Bool, status : String, tag : String) {
        self.productIdentifier = productIdentifier
        self.localizedTitleSuffix = localizedTitleSuffix
        self.freeTrialDays = freeTrialDays
        self.features = features
        self.oldUserDefaultKeyIfAny = oldUserDefaultKeyIfAny
        self.cellImage = cellImage
        self.title = title
        self.subtitle = subTitle
        self.tag = tag
        self.isHighlighted = isHighlighted
        self.status = status
    }

    public func productType(for product: Product) -> IAPProductType {
        if product.subscription == nil {
            return .oneTime
        } else {
            return .autoRenewable
        }
    }

    public func productLife(for product: Product) -> IAPProductLife {
        guard let subscription = product.subscription else {
            return .lifetime
        }

        switch subscription.subscriptionPeriod.unit {
        case .month:
            return .monthly
        case .day:
            return .daily
        case .week:
            return .weekly
        case .year:
            return .yearly
        @unknown default:
            return .unknown
        }
    }

    public func productPrice(for product: Product) -> Double? {
        return Double(truncating: product.price as NSDecimalNumber)
    }

    public func priceDescription(for product: Product) -> String? {
        guard let subscription = product.subscription, subscription.subscriptionPeriod.unit == .year,
              let price = productPrice(for: product) else { return nil }

        // Use a default locale, or you could use the user's current locale
        let locale = Locale.current
        let monthlyPrice = calculateMonthlyPrice(yearlyPrice: price, locale: locale)
        return "\(monthlyPrice) \(localizedTitleSuffix)"
    }

    public func discount(for product: Product) -> Int? {
        guard let subscription = product.subscription, subscription.subscriptionPeriod.unit == .year,
              let price = productPrice(for: product) else { return nil }

        // Define a reference price for monthly subscription
        let monthlyPrice = 9.99 // Assume a default monthly price
        let yearlyPrice = monthlyPrice * 12
        let discount = ((yearlyPrice - price) / yearlyPrice) * 100
        return Int(discount.rounded())
    }

    public var isActive: Bool {
        get {
            guard let key = oldUserDefaultKeyIfAny, !key.isEmpty else { return false }
            return UserDefaults.standard.bool(forKey: key)
        }
        set {
            guard let key = oldUserDefaultKeyIfAny, !key.isEmpty else { return }
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }

    public func priceLabel(for product: Product) -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale.current // Default locale
        
        let price = product.price
        return numberFormatter.string(from: price as NSDecimalNumber)
    }

    private func calculateMonthlyPrice(yearlyPrice: Double, locale: Locale) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = locale

        let numberOfMonthsInYear = 12
        let monthlyEquivalentPrice = yearlyPrice / Double(numberOfMonthsInYear)
        return numberFormatter.string(from: NSNumber(value: monthlyEquivalentPrice)) ?? ""
    }

    public static func productIdentifier(for lifeLine: IAPProductLife) -> String {
        switch lifeLine {
        case .monthly: return Monthly.productIdentifier
        case .yearly: return Yearly.productIdentifier
        case .weekly: return Weekly.productIdentifier
        case .lifetime: return LifeTime.productIdentifier
        case .daily: return Daily.productIdentifier
        case .unknown: return Free.productIdentifier
        }
    }

    public static func getProduct(for identifier: String) -> IAPProduct? {
        switch identifier {
        case Free.productIdentifier: return Free
        case Yearly.productIdentifier: return Yearly
        case Monthly.productIdentifier: return Monthly
        case LifeTime.productIdentifier: return LifeTime
        case Weekly.productIdentifier: return Weekly
        case Daily.productIdentifier: return Daily
        default: return nil
        }
    }

    public static let LifeTime = IAPProduct(
        productIdentifier: "",
        localizedTitleSuffix: "Premium",
        freeTrialDays: 7,
        features: ["Feature 1", "Feature 2"],
        oldUserDefaultKeyIfAny: nil,
        cellImage: Image("p1"),
        title : "title",
        subTitle : "subTitle",
        isHighlighted : false,
        status : "",
        tag : ""
        
    )

    public static let Yearly = IAPProduct(
        productIdentifier: "",
        localizedTitleSuffix: "Premium",
        freeTrialDays: 7,
        features: ["Feature 1", "Feature 2"],
        oldUserDefaultKeyIfAny: nil,
        cellImage: Image("p2"),
        title : "title",
        subTitle : "subTitle",
        isHighlighted : false,
        status : "",
        tag : ""
    )

    public static let Monthly = IAPProduct(
        productIdentifier: "",
        localizedTitleSuffix: "Premium",
        freeTrialDays: 7,
        features: ["Feature 1", "Feature 2"],
        oldUserDefaultKeyIfAny: nil,
        cellImage: Image("p2"),
        title : "title",
        subTitle : "subTitle",
        isHighlighted : false,
        status : "",
        tag : ""
    )

    public static let Weekly = IAPProduct(
        productIdentifier: "",
        localizedTitleSuffix: "Premium",
        freeTrialDays: 7,
        features: ["Feature 1", "Feature 2"],
        oldUserDefaultKeyIfAny: nil,
        cellImage: Image("p2"),
        title : "title",
        subTitle : "subTitle",
        isHighlighted : false,
        status : "",
        tag : ""
    )

    public static let Free = IAPProduct(
        productIdentifier: "",
        localizedTitleSuffix: "Premium",
        freeTrialDays: 7,
        features: ["Feature 1", "Feature 2"],
        oldUserDefaultKeyIfAny: nil,
        cellImage: Image("p2"),
        title : "title",
        subTitle : "subTitle",
        isHighlighted : false,
        status : "",
        tag : ""
    )

    public static let Daily = IAPProduct(
        productIdentifier: "",
        localizedTitleSuffix: "Premium",
        freeTrialDays: 7,
        features: ["Feature 1", "Feature 2"],
        oldUserDefaultKeyIfAny: nil,
        cellImage: Image("p2"),
        title : "title",
        subTitle : "subTitle",
        isHighlighted : false,
        status : "",
        tag : ""
    )
}
