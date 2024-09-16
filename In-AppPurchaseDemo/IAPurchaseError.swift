//
//  IAPurchaseError.swift
//  In-AppPurchaseDemo
//
//  Created by Neeshu Kumar on 10/09/24.
//

import Foundation

public enum IAPurchaseError  {
    
    case productNotFound(log: String)
    case purchaseFailed(log: String)
    case restoreFailed(log: String)
    case invalidReceipt(log: String)
    case receiptExpired(log: String)
    case paymentCancelled(log: String)
    case networkError(log: String)
    case unknownError(log: String)
    
   public var displayTitle: String {
            switch self {
                case .productNotFound:
                return "Purchase_Not_Found"
                case .purchaseFailed:
                return "Purchase_Failed_"
                case .restoreFailed:
                return "Purchase_Not_Found"
                case .invalidReceipt:
                return "Invalid_receipt"
                case .receiptExpired:
                return "Invalid_receipt"
                case .paymentCancelled:
                return "Payment_Failed_"
                case .networkError:
                return "_NoInternet"
                case .unknownError:
                return "Unknown error"
            }
        }
    
    public var logDescription: String {
        switch self {
            case .productNotFound(let description),
                 .purchaseFailed(let description),
                 .restoreFailed(let description),
                 .invalidReceipt(let description),
                 .receiptExpired(let description),
                 .paymentCancelled(let description),
                 .networkError(let description),
                 .unknownError(let description):
                return description
        }
    }
    
}
