//
//  ContentView.swift
//  In-AppPurchaseDemo
//
//  Created by Neeshu Kumar on 10/09/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        IAPView(iapViewModel: IAPViewModel(isSingleTemplateSelectedOrNot: true, image: Image("p1")))
    }
}

#Preview {
    ContentView()
}
