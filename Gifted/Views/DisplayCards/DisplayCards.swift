//
//  DisplayCards.swift
//  Gifted
//
//  Created by Edwin Tang on 31/12/2022.
//

import Amplify
import SwiftUI


struct DisplayCards: View {
    let cardWidth = UIScreen.main.bounds.size.width * 42/100
    let cardHeight = UIScreen.main.bounds.size.height * 3/10
    let cornerRadius = 7.0
    
    @State var listItem: ListItem
    @Binding var ImageCache: [String: UIImage]
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .cardBackgroundandShadow(cornerRadius: cornerRadius)
                .frame(width: cardWidth, height: cardHeight)
            if let key = listItem.ImageKey, let render = ImageCache[key] {
                VStack(alignment: .center) {
                    Image(uiImage: render)
                        .resizable()
                        .padding([.top,.leading, .trailing])
                        .aspectRatio(contentMode: .fill)
                        .frame(width: cardWidth, height: cardHeight*5/6)
                        .clipShape(
                            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                    cardDetails
                        .frame(width: cardWidth, height: cardHeight*1/6)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                }
                .padding(.all)
                .frame(width: cardWidth, height: cardHeight)
            } else {
                Text(listItem.Name)
                    .padding(.all)
            }
            
        }
        .padding(.top)
        .onAppear{
            getImage(Imagekey: listItem.ImageKey)
        }
    }
    
    var cardDetails: some View{
        VStack(alignment: .leading) {
            Text(listItem.Name)
                .itemText()
                .fixedSize(horizontal: false, vertical: true)
                .lineLimit(1)
            if let price = listItem.Price {
                Text("$\(price)")
                    .itemText()
            }
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

struct HorizontalDisplayCards: View {
    let cardWidth = UIScreen.main.bounds.size.width * 18/20
    let cardHeight = UIScreen.main.bounds.size.height * 3/20
    let cornerRadius = 7.0
    
    @State var listItem: ListItem
    @Binding var ImageCache: [String: UIImage]
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .cardBackgroundandShadow(cornerRadius: cornerRadius)
                .frame(width: cardWidth, height: cardHeight)
            if let key = listItem.ImageKey, let render = ImageCache[key] {
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
                Text(listItem.Name)
            }
            
        }
        .padding(.top)
        .onAppear{
            getImage(Imagekey: listItem.ImageKey)
        }
    }
    
    var cardDetails: some View{
        VStack(alignment: .leading) {
            Text(listItem.Name)
                .itemText()
                .fixedSize(horizontal: false, vertical: true)
                .lineLimit(2)
            Spacer()
            HStack {
                if let price = listItem.Price {
                    Text("$\(price)")
                        .itemText()
                }
                Spacer()
                Image(systemName: "chevron.right")
            }
            
        }
        .padding(.vertical)
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

//struct DisplayCards_Previews: PreviewProvider {
//    static var previews: some View {
//        DisplayCards()
//    }
//}
