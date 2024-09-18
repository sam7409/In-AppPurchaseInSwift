//
//  SubscribedView.swift
//  In-AppPurchaseDemo
//
//  Created by Neeshu Kumar on 18/09/24.
//

import SwiftUI
import StoreKit
import Lottie

struct SubscribedView: View {
    var subscriptionType: String
    var product: Product
    @StateObject var iapViewModel: IAPViewModel

    var attributedPremiumText: AttributedString {
        var attributedString = AttributedString("You are ")

        var subscriptionType = AttributedString(subscriptionType)
        subscriptionType.foregroundColor = .pink

        let lastString = AttributedString("Subscribed ☺️")

        attributedString.append(subscriptionType)
        attributedString.append(lastString)

        return attributedString
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack{
                VStack {
                    
                    // Subscribed text
                    Text(attributedPremiumText)
                        .fontWeight(.bold)
                        .font(.system(size: 65))
                    
                    // Manage Plans button
                    Button(action: {
                        iapViewModel.purchaseProduct(product: product)
                    }) {
                        Text("Manage Plans")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: geometry.size.width * 0.9)
                            .padding()
                            .background(Color.pink)
                            .cornerRadius(10)
                    }
                    .padding(.top, 20)
                }
                .padding()
                
                // Display the blast effect using Lottie animation
                LottieView(animationName: "blastEffect", loopMode: .playOnce)
                    .frame(width: geometry.size.width * 0.9, height: geometry.size.height * 0.95)
                
                // Overlay the image at the top right corner
               Image("celebrate")
                   .resizable()
                   .frame(width: 80, height: 80)
                   .padding(.trailing)
                   .position(x: geometry.size.width - 35, y: 50)
            }
        }
    }
}
