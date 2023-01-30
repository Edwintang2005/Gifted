//
//  FriendsDetailsView.swift
//  Gifted
//
//  Created by Edwin Tang on 28/1/2023.
//

import Amplify
import SwiftUI

struct FriendsDetailsView: View {
    
    @ObservedObject var dataStore = DataStore()
    @EnvironmentObject var sessionManager: SessionManager
    
    @Binding var displayPopup: popupState
    @Binding var ImageCache: [String: UIImage]
    @Binding var friend: UserProfile
    
    let userID = UserDefaults.standard.string(forKey: "UserID") ?? "NullUser"
    let cardWidth = UIScreen.main.bounds.size.width
    let cardHeight = UIScreen.main.bounds.size.height * 1/3
    let cornerRadius = 10.0
    
    var body: some View {
        VStack {
            FriendDisplayInfo(friend: friend, ImageCache: $ImageCache)
            Button {
                displayPopup = .friendWishlist
            } label: {
                Text("View Wishlist")
            }.long()
            Button {
                deleteFriend()
                displayPopup = .None
            } label: {
                Text("Remove Friend")
            }.long()
        }
        .background(Color(.sRGB, red: 237/255, green: 240/255, blue: 241/255))
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    }
    
    func deleteFriend() {
        // Function to remove friend from list
        dataStore.changeFriends(action: .removeFrom, userID: userID, change: friend)
    }
}

struct FriendDisplayInfo: View {
    let cardWidth = UIScreen.main.bounds.size.width * 18/20
    let cardHeight = UIScreen.main.bounds.size.height * 3/20
    let cornerRadius = 10.0
    
    @ObservedObject var dataStore = DataStore()
    @State var friend: UserProfile
    @Binding var ImageCache: [String: UIImage]
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .foregroundColor(Color(.sRGB, red: 237/255, green: 240/255, blue: 241/255))
                .frame(width: cardWidth, height: cardHeight)
            if let key = friend.ImageKey, let render = ImageCache[key] {
                HStack{
                    // Small Icon Image Rendering
                    Image(uiImage: render)
                        .resizable()
                        .padding(.all)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: cardHeight, height: cardHeight)
                        .clipShape(
                            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                    cardDetails
                    .padding(.horizontal)
                    Spacer()
                }
                .frame(width: cardWidth, height: cardHeight)
            } else {
                cardDetails
                    .padding(.all)
            }
        }
        .onAppear{
            getImage(Imagekey: friend.ImageKey)
        }
    }
    
    var cardDetails: some View{
        HStack {
            VStack(alignment: .leading) {
                Text(friend.Username)
                    .itemText()
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(2)
                if let name = friend.Name {
                    Text(name)
                        .itemText()
                }
            }
            .padding(.vertical)
            Spacer()
        }
    }
    
    
    func getImage(Imagekey: String?) {
        guard let Key = Imagekey else {return}
        if ImageCache.keys.contains(Key) {
            return
        } else {
            Amplify.Storage.downloadData(key: Key) { result in
                switch result {
                case .success(let ImageData):
                    print("Fetched ImageData")
                    let image = UIImage(data: ImageData)
                    DispatchQueue.main.async{
                        ImageCache[Key] = image
                    }
                    return
                case .failure(let error):
                    print("Could not get Image URL - \(error)")
                }
            }
        }
    }
}


// Simulator code below, ignore

//struct FriendsDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        FriendsDetailsView()
//    }
//}
