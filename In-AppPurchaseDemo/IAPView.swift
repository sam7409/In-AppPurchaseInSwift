//
//  PremiumView.swift
//  In-AppPurchaseDemo
//
//  Created by Neeshu Kumar on 10/09/24.
//

import SwiftUI

struct IAPView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var iapViewModel : IAPViewModel
    @State var selectedProductId: String? = nil
    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
    
    let singleTemplateProduct = IAPProduct(productIdentifier: "com.irisstudio.watermarkpro.monthly", localizedTitleSuffix: "", freeTrialDays: 7, features: ["No Watermark", "Unlock Single Template"], oldUserDefaultKeyIfAny: "", cellImage: Image("p1"), title: "Single", subTitle: "Only One Template", isHighlighted: false, status: "", tag: "/ Only One")
    
    let monthlyTemplateProduct =  IAPProduct(productIdentifier: "com.irisstudio.watermarkpro.monthly", localizedTitleSuffix: "", freeTrialDays: 7, features: ["No Ads - No Watermark", "All Premium Content"], oldUserDefaultKeyIfAny: "", cellImage: Image("p2"), title: "Monthly", subTitle: "Full Access Subscription", isHighlighted: false, status: "Most Popular", tag: "/ Monthly")
    
    let yearlyTemplateProduct =  IAPProduct(productIdentifier: "com.irisstudio.watermarkpro.monthly", localizedTitleSuffix: "", freeTrialDays: 7, features: ["No Ads - No Watermark", "All Premium Content"], oldUserDefaultKeyIfAny: "", cellImage: Image("p2"), title: "Yearly", subTitle: "Full Access Subscription", isHighlighted: true, status: "Save 80%", tag: "/ Yearly")

    
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
                
                
                
                ScrollView{
                    // Subscription Options
                    VStack(spacing: 10) {
                        ForEach(iapViewModel.availableProducts, id: \.id) { product in
                            // Single template option
                            if product.type.rawValue == "Consumable"{
                                // Single template option
                                SubscriptionOptionView(iaProduct: singleTemplateProduct, price: product.displayPrice, selectedProductId: $selectedProductId, productId : product.id ).onTapGesture {
                                    // Trigger haptic feedback
                                    impactFeedback.impactOccurred()
                                    selectedProductId = product.id
                                    iapViewModel.currentSelectedProduct = product
                                    print("\(product.displayPrice)")
                                }
                            }
                            
                            else if product.subscription?.subscriptionPeriod.unit == .month{
                                // Monthly subscription option
                                SubscriptionOptionView(iaProduct: monthlyTemplateProduct, price : product.displayPrice, selectedProductId: $selectedProductId, productId : product.id)
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
                                SubscriptionOptionView(iaProduct: yearlyTemplateProduct, price : product.displayPrice, selectedProductId: $selectedProductId, productId : product.id)
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
                .frame(width: geometry.size.width) // Ensure it takes up the full width
                .padding(.vertical)
        }
    }
}


//struct PremiumView_Previews: PreviewProvider {
//    static var previews: some View {
//        IAPView()
//    }
//}
