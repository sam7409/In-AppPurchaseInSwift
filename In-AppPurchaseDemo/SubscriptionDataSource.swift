//
//  SubscriptionDataSource.swift
//  In-AppPurchaseDemo
//
//  Created by Neeshu Kumar on 11/09/24.
//

import Foundation
import SwiftUI

enum SubscriptionType{
    case consumable
    case monthly
    case yearly
}

class PremiumDataSource {
    static let shared = PremiumDataSource()

    private init() {}

    private var dataSources: [SubscriptionType: SubscriptionOptionViewModel] = [:]

    func loadData() {
        dataSources[.consumable] = SubscriptionOptionViewModel(
            image: Image("p1"),
            title: "Single",
            subtitle: "Only One Template",
            price: "$3.99",
            description: ["No Watermark", "Unlock Single Template"],
            tag: "/ Only One",
            isHighlighted: false,
            status: ""
        )
        
        dataSources[.monthly] = SubscriptionOptionViewModel(
            image: Image("p2"),
            title: "Monthly",
            subtitle: "Full Access Subscription",
            price: "$4.99",
            description: ["No Ads - No Watermark", "All Premium Content"],
            tag: "/ Monthly",
            isHighlighted: true,
            status: "Most Popular"
        )
        
        dataSources[.yearly] = SubscriptionOptionViewModel(
            image: Image("p2"),
            title: "Yearly",
            subtitle: "Full Access Subscription",
            price: "$14.99",
            description: ["No Ads - No Watermark", "All Premium Content"],
            tag: "/ Yearly",
            isHighlighted: false,
            status: "Save 80%"
        )
    }

    func getData(for type: SubscriptionType) -> SubscriptionOptionViewModel? {
        return dataSources[type]
    }
}
