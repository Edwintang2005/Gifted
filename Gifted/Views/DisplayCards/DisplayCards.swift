//
//  DisplayCards.swift
//  Gifted
//
//  Created by Edwin Tang on 31/12/2022.
//

import Amplify
import SwiftUI


struct DisplayCards: View {
    let cardWidth = UIScreen.main.bounds.size.width * 43/100
    let cardHeight = UIScreen.main.bounds.size.height * 1/4
    let cornerRadius = 7.0
    
    @State var listItem: ListItem
    @State var ImageCache = [String: UIImage]()
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .frame(width: cardWidth, height: cardHeight)
                .foregroundColor(.white)
            if let key = listItem.ImageKey, let render = ImageCache[key] {
                VStack(alignment: .leading) {
                    Image(uiImage: render)
                        .resizable()
                        .padding(.all)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: cardWidth, height: cardHeight*9/10)
                        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                    Spacer()
                    cardDetails
                        .padding(.horizontal)
                        .frame(width: cardWidth)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                }
                .border(.gray)
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
                .lineLimit(2)
            HStack(spacing: 0.4) {
                if let price = listItem.Price {
                    Text("$\(price)")
                }
            }.foregroundColor(.gray)
                .padding(.bottom)
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



//struct DisplayCards_Previews: PreviewProvider {
//    static var previews: some View {
//        DisplayCards()
//    }
//}
