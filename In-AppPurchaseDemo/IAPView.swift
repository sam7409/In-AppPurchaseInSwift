//
//  PremiumView.swift
//  In-AppPurchaseDemo
//
//  Created by Neeshu Kumar on 10/09/24.
//

import SwiftUI
import StoreKit

struct IAPView: View {
    @EnvironmentObject var environmentObject: EnvironmentObj
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var iapViewModel : IAPViewModel
    @State var selectedProductId: String? = nil
    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)

    
    var attributedText: AttributedString {
        var attributedString = AttributedString("By continuing you agree to the ")
        
        // Create the part of the string that should be blue
        var termsAndConditions = AttributedString("Terms & Conditions")
        termsAndConditions.foregroundColor = .blue
        
        // Append the styled part to the main string
        attributedString.append(termsAndConditions)
        
        // Append the rest of the string
        attributedString.append(AttributedString("."))
        
        return attributedString
    }
    
    
    var attributedPremiumText: AttributedString {
        var attributedString = AttributedString("Go Premium and ")
        
        // Create the part of the string that should be blue
        var standOut = AttributedString("Stand Out ")
        standOut.foregroundColor = .pink
        
        let lastString = AttributedString("with Premium Content")
        
        // Append the styled part to the main string
        attributedString.append(standOut)
        attributedString.append(lastString)
        
        // Append the rest of the string
        attributedString.append(AttributedString("."))
        
        return attributedString
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                // Header with title and close button
                HStack {
                    Image("Premium").resizable()
                        .frame(width: 20, height: 20)
                        .padding(.bottom, 10)
                    
                    Image("Partyza")
                        .resizable()
                        .frame(width: 90, height: 40)
                        .padding(.leading, 10)
                    
                    
                    Spacer()
                    
                    Button(action: {
                        // Close button action: dismiss the view
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.pink)
                            .padding()
                    }
                }
                .padding(.horizontal)
                VStack{
                    // Main Title
                    Text(attributedPremiumText)
                        .font(.title3)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 20)
                }.frame(height: 150)
                
                
                if iapViewModel.purchasedProducts.isEmpty{
                    ScrollView{
                        // Subscription Options
                        VStack(spacing: 10) {
                            ForEach(iapViewModel.availableProducts, id: \.id) { product in
                                // Single template option
                                if product.type.rawValue == "Consumable" && iapViewModel.isSingleTemplateSelectedOrNot{
                                    // Single template option
                                    SubscriptionOptionView(iaProduct: iapViewModel.singleTemplateProduct, price: product.displayPrice, selectedProductId: $selectedProductId, product : product, purchasedProduct : $iapViewModel.purchasedProducts).onTapGesture {
                                        // Trigger haptic feedback
                                        impactFeedback.impactOccurred()
                                        selectedProductId = product.id
                                        iapViewModel.currentSelectedProduct = product
                                        print("\(product.displayPrice)")
                                    }
                                }
                                
                                else if product.subscription?.subscriptionPeriod.unit == .month{
                                    // Monthly subscription option
                                    SubscriptionOptionView(iaProduct: iapViewModel.monthlyTemplateProduct, price : product.displayPrice, selectedProductId: $selectedProductId, product : product, purchasedProduct : $iapViewModel.purchasedProducts)
                                        .onTapGesture {
                                            // Trigger haptic feedback
                                            impactFeedback.impactOccurred()
                                            selectedProductId = product.id
                                            iapViewModel.currentSelectedProduct = product
                                            print("\(product.displayPrice)")
                                        }
                                }
                                
                                else if product.subscription?.subscriptionPeriod.unit == .year{
                                    // Yearly subscription option
                                    SubscriptionOptionView(iaProduct: iapViewModel.yearlyTemplateProduct, price : product.displayPrice, selectedProductId: $selectedProductId, product : product, purchasedProduct : $iapViewModel.purchasedProducts)
                                        .onTapGesture {
                                            // Trigger haptic feedback
                                            impactFeedback.impactOccurred()
                                            selectedProductId = product.id
                                            iapViewModel.currentSelectedProduct = product
                                            print("\(product.displayPrice)")
                                        }
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    
                    
                    
                    if iapViewModel.currentSelectedProduct != nil && iapViewModel.currentSelectedProduct?.type.rawValue != "Consumable"{
                        // Cancel anytime message
                        Text("Cancel Anytime")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.top, 10)
                    }
                    
                    // Continue button
                    Button(action: {
                        if let currentSelectedProduct = iapViewModel.currentSelectedProduct{
                            iapViewModel.purchaseProduct(product: currentSelectedProduct)
                        }
                    }) {
                        Text("Continue")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: geometry.size.width * 0.9) // Adjust the width
                            .padding()
                            .background(Color.pink)
                            .cornerRadius(10)
                    }
                    .padding(.top, 20)
                    
                    // Restore Purchase
                    Button(action: {
                        iapViewModel.restorePurchases()
                    }) {
                        Text("Restore Purchase")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                    .padding(.top, 10)
                    
                    Text(attributedText)
                        .font(.caption2)
                        .padding(.top, 10)
                    
                    Spacer()
                }
                else{
                    let product = iapViewModel.purchasedProducts.first!
                    if product.subscription?.subscriptionPeriod.unit == .year{
                        SubscribedView(subscriptionType: "Yearly ", product: iapViewModel.purchasedProducts.first!, iapViewModel: iapViewModel)
                    }
                    else{
                        SubscribedView(subscriptionType: "Monthly ", product: iapViewModel.purchasedProducts.first!, iapViewModel: iapViewModel)
                    }
                }
            }
            .frame(width: geometry.size.width) // Ensure it takes up the full width
            .padding(.vertical)
            .onReceive(iapViewModel.$purchaseStatus) { purchaseStatus in
                if purchaseStatus == .success{
                    environmentObject.isPremium = true
                }
                else if purchaseStatus == .failure{
                    environmentObject.isPremium = false
                }
            }
        }
            
    }
}


//struct PremiumView_Previews: PreviewProvider {
//    static var previews: some View {
//        IAPView()
//    }
//}
