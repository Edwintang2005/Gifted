//
//  FriendDisplayCards.swift
//  Gifted
//
//  Created by Roger Yao on 23/1/2023.
//

import Amplify
import SwiftUI


struct FriendDisplayCards: View {
    let cardWidth = UIScreen.main.bounds.size.width * 18/20
    let cardHeight = UIScreen.main.bounds.size.height * 3/20
    let cornerRadius = 7.0
    
    @ObservedObject var dataStore = DataStore()
    @State var friend: UserProfile
    @Binding var ImageCache: [String: UIImage]
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .foregroundColor(.white)
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
            Image(systemName: "chevron.right")
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



//struct FriendDisplayCards_Previews: PreviewProvider {
//    static var previews: some View {
//        FriendDisplayCards()
//    }
//}
