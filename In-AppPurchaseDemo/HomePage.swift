//
//  HomePage.swift
//  In-AppPurchaseDemo
//
//  Created by Neeshu Kumar on 18/09/24.
//

import SwiftUI

struct HomePage: View {
    @EnvironmentObject var environmentObject: EnvironmentObj
    @State var withConsumable : Bool = false
    @State var withoutConsumable : Bool = false
    var body: some View {
        VStack {
            Button {
                withConsumable = true
                
            } label: {
                Text("With Consumable")
            }
            
            Button {
                withoutConsumable = true
               
            } label: {
                Text("Without Consumable")
            }
        }
        .sheet(isPresented: $withConsumable) {
            IAPView(iapViewModel: IAPViewModel(isSingleTemplateSelectedOrNot: true, image: Image("p1")))
        }
        .sheet(isPresented: $withoutConsumable) {
            IAPView(iapViewModel: IAPViewModel(isSingleTemplateSelectedOrNot: false))
        }
        .onReceive(environmentObject.$isPremium) { purchaseStatus in
            if purchaseStatus{
                print("Purchased Successfully.")
            }
            else{
                print("Not Purchased Successfully.")
            }
        }
    }
}

#Preview {
    HomePage()
}
