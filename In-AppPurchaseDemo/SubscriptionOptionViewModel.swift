//
//  SubscriptionOptionViewModel.swift
//  In-AppPurchaseDemo
//
//  Created by Neeshu Kumar on 11/09/24.
//

import Foundation
import SwiftUI


class SubscriptionOptionViewModel {
     var image: Image
     var title: String
     var subtitle: String
     var price: String?  // Use @Published for optional string
     var description: [String]
     var tag: String
     var isHighlighted: Bool
     var status: String

    init(image: Image, title: String, subtitle: String, price: String?, description: [String], tag: String, isHighlighted: Bool, status: String) {
        self.image = image
        self.title = title
        self.subtitle = subtitle
        self.price = price
        self.description = description
        self.tag = tag
        self.isHighlighted = isHighlighted
        self.status = status
    }
}
