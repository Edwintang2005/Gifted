//
//  FriendListView.swift
//  Gifted
//
//  Created by Edwin Tang on 30/1/2023.
//

import SwiftUI

struct FriendListView: View{
    
    @ObservedObject var dataStore = DataStore()
    @Binding var displayPopup: popupState
    @Binding var friend: UserProfile
    @Binding var ImageCache: [String: UIImage]
    
    @State var listItems = [ListItem]()
    
    
    let userID = UserDefaults.standard.string(forKey: "UserID") ?? "NullUser"
    
    let cardWidth = UIScreen.main.bounds.size.width * 99/100
    let cardHeight = UIScreen.main.bounds.size.height * 4/5
    let cornerRadius = 10.0
    
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    displayPopup = .None
                } label: {
                    Image(systemName: "x.circle")
                        .imageScale(.large)
                }
            }
            .padding(.top)
            VStack {
                Text("\(friend.Name)'s Wishlist")
                    .boldText()
                if listItems.count == 0 {
                    VStack {
                        Spacer()
                        Text("Your friend is satisfied and has no list items!")
                        Spacer()
                    }
                } else {
                    ScrollView(showsIndicators: false) {
                        ForEach(listItems) { item in
                            HorizontalDisplayCards(listItem: item, ImageCache: $ImageCache)
                        }
                    }
                }
            }
            .padding(.bottom)
        }
        .background(Color(.sRGB, red: 237/255, green: 240/255, blue: 241/255))
        .padding(.all)
        .frame(width: cardWidth, height: cardHeight)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .onAppear{
            getListItem()
        }
    }
    
    func getListItem() {
        if let id = friend.Lists.first {
            listItems = dataStore.fetchListItems(listid: id)
        }
    }
}
//struct FriendListView_Previews: PreviewProvider {
//    static var previews: some View {
//        FriendListView()
//    }
//}
