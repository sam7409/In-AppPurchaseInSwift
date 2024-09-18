//
//  environmentObject.swift
//  In-AppPurchaseDemo
//
//  Created by Neeshu Kumar on 18/09/24.
//

import Foundation
import Combine

class EnvironmentObj : ObservableObject{
    @Published var isPremium : Bool = false
    
    init(){}
}
