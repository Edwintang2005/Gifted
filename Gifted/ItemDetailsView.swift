//
//  ItemDetailsView.swift
//  Gifted
//
//  Created by Edwin Tang on 3/12/2022.
//

import SwiftUI

struct ItemDetailsView: View {
    var body: some View {
        ScrollView{
            VStack {
                VStack(spacing: 40) {
                    // Image of item
                    Image(uiImage: UIImage(named: "ItemDetailsViewStock1.jpg") ?? .init())
                        .renderingMode(.original)
                        .resizable()
                        .padding(.vertical)
                        .aspectRatio(contentMode: .fit)
                        .mask { RoundedRectangle(cornerRadius: 4, style: .continuous) }
                }
                // Overlay of image to represent people who have reserved the item
                    .overlay(alignment: .topTrailing) {
                        HStack {
                            Image(systemName: "a.circle.fill")
                                .imageScale(.large)
                        }
                        .font(.title3)
                        .padding(.all)
                        .shadow(color: Color(.displayP3, red: 0/255, green: 0/255, blue: 0/255).opacity(0.11), radius: 8, x: 0, y: 4)
                    }
                .mask {
                    Rectangle()
                }
                
                HStack {
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Simple item description") // Replace with item description
                            .font(.headline.weight(.medium))
                            .lineLimit(2)
                        Text("From Store A") // Replace with store
                            .font(.subheadline.weight(.medium))
                            .lineLimit(2)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    Text("$Price") // Replace with Item Price
                        .font(.body)
                        .foregroundColor(.primary)
                }
                    .padding(.horizontal)
                
                Spacer()
                // Button for reserving purchase
                Button {
                        print("Reserve Button Clicked") // Dud function to be replaced later
                    }
                        label: {
                                Text("Reserve for purchase")
                            }
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.all)
                    .foregroundColor(.white)
                    .background {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .foregroundColor(.pink)
                            .padding(.horizontal)
                    }
                
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.vertical)

        }
        .navigationTitle("Item Name")
    }
}



//struct ItemDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemDetailsView()
//    }
//}
