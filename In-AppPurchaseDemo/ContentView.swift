//
//  ContentView.swift
//  In-AppPurchaseDemo
//
//  Created by Neeshu Kumar on 10/09/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
//        VStack {
////            IAPView(viewModel: IAPViewModel())
//
//        }
        IAPView(iapViewModel: IAPViewModel())
        
    }
}

#Preview {
    ContentView()
}
