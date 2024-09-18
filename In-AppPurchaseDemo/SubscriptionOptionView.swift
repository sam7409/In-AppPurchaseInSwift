//
//  PremiumCellView.swift
//  In-AppPurchaseDemo
//
//  Created by Neeshu Kumar on 10/09/24.
//


import SwiftUI
import StoreKit

struct SubscriptionOptionView: View {
    var iaProduct : IAPProduct
    var price : String
    @Binding var selectedProductId: String?
    var product : Product
    var subscription : Subscription?
    @Binding var purchasedProduct : Set<Product> 
   
    
    var body: some View {
        VStack{
        HStack(alignment: .center) {
            // Placeholder for the image
            iaProduct.cellImage!
                .resizable()
                .frame(width: 60, height: 60)
                .cornerRadius(10)
                .padding(.trailing, 10)
            
            VStack(alignment: .leading, spacing: 5) {
                // Title and Subtitle
                Text(iaProduct.title)
                    .font(.headline).bold()
                    .foregroundColor(selectedProductId == product.id ? Color.pink : Color.black)
                
                Text(iaProduct.subtitle).bold()
                    .font(.caption)
                    .foregroundColor(selectedProductId == product.id ? Color.pink : Color.black)
                
                // Features
                ForEach(iaProduct.features, id: \.self) { item in
                    VStack(alignment: .leading, spacing: 2) {
                        Text("• \(item)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }
            
            Spacer()
            
            // Price and Tag
            VStack(alignment: .trailing) {
                Text("\(price)")
                    .font(.headline)
                    .foregroundColor(.black)
                
                Text(iaProduct.tag)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        
            VStack(alignment: .center, content: {
                if purchasedProduct.contains(product){
                    Text("Purchased").foregroundColor(.green)
                }
            })
    }
        .padding()
        .overlay(
            Group {
                if iaProduct.status != "" {
                    // "Most Popular" Badge
                    Text(iaProduct.status)
                        .font(.caption)
                        .foregroundColor(.black)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(iaProduct.status == "Most Popular" ? Color(red: 0.690, green: 0.812, blue: 0.494, opacity: 1.0) :  Color(red: 1.0, green: 0.8078, blue: 0.0, opacity: 1.0))
                        .cornerRadius(5)
                        .padding(.top, 1.3)
                        .padding(.trailing, 1.3)
                }
            },
            alignment: .topTrailing
        )
        .background(
            RoundedRectangle(cornerRadius: 10)
                .stroke(
                    purchasedProduct.contains(product) ? Color.green :
                    (selectedProductId == product.id ? Color.pink : Color.gray), lineWidth: 2
                )
        )
        .padding(.horizontal)
    }
    
}

//
//#Preview {
//    SubscriptionOptionView(image: Image("p1"), title: "Single", subtitle: "Only One Template", price: "$3.99", description: ["No Watermark", "Unlock Single Template"], tag: "/ Only One", isHighlighted: true, status: "Save 80%")
//}
