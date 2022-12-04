//
//  ListView.swift
//  Gifted
//
//  Created by Edwin Tang on 4/12/2022.
//

import SwiftUI

struct ListView: View {
    @EnvironmentObject var sessionManager: SessionManager
    
    var body: some View {
        ZStack {
            ScrollView{
                VStack {
                    HStack(spacing: 10) {
                        Image(uiImage: UIImage(named: "WishlistLoading.jpg") ?? .init())
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 70, height: 70)
                            .clipped()
                            .mask { RoundedRectangle(cornerRadius: 8, style: .continuous) }
                        VStack(alignment: .leading, spacing: 2) {
                            Text("New York City")
                                .font(.system(size: 16, weight: .medium, design: .default))
                            Text("Dec 12")
                        }
                        .font(.subheadline)
                        Spacer()
                        Image(systemName: "ellipsis")
                            .foregroundColor(Color(.displayP3, red: 234/255, green: 76/255, blue: 97/255))
                            .font(.title3)
                    }
                    .padding(.bottom, 4)
                    HStack(spacing: 10) {
                        Image(uiImage: UIImage(named: "WishlistLoading.jpg") ?? .init())
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 70, height: 70)
                            .clipped()
                            .mask { RoundedRectangle(cornerRadius: 8, style: .continuous) }
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Palm Springs")
                                .font(.system(size: 16, weight: .medium, design: .default))
                            Text("Jan 7 2021")
                        }
                        .font(.subheadline)
                        Spacer()
                        Image(systemName: "ellipsis")
                            .foregroundColor(Color(.displayP3, red: 234/255, green: 76/255, blue: 97/255))
                            .font(.title3)
                    }
                    .padding(.bottom, 4)
                    HStack(spacing: 10) {
                        Image(uiImage: UIImage(named: "WishlistLoading.jpg") ?? .init())
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 70, height: 70)
                            .clipped()
                            .mask { RoundedRectangle(cornerRadius: 8, style: .continuous) }
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Lisbon")
                                .font(.system(size: 16, weight: .medium, design: .default))
                            Text("March 13 2021")
                        }
                        .font(.subheadline)
                        Spacer()
                        Image(systemName: "ellipsis")
                            .foregroundColor(Color(.displayP3, red: 234/255, green: 76/255, blue: 97/255))
                            .font(.title3)
                    }
                    .padding(.bottom, 4)
                    Spacer()
                    
                }
                .padding(.horizontal, 24)
                Spacer()
            }
            .padding(.top)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
        .mask { RoundedRectangle(cornerRadius: 53, style: .continuous) }
        .overlay( Floating_Button_List(), alignment: .bottomTrailing)
        .padding(.vertical, 40)
        .navigationBarTitle("My List")
    }
}




//struct ListView_Previews: PreviewProvider {
//    static var previews: some View {
//        ListView()
//    }
//}
