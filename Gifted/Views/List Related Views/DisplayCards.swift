//
//  DisplayCards.swift
//  Gifted
//
//  Created by Edwin Tang on 31/12/2022.
//

import SwiftUI




struct DisplayCards: View {
    let cardWidth = UIScreen.main.bounds.size.width * 5/9
    let cardHeight = UIScreen.main.bounds.size.width * 5/6
    let cornerRadius = 15.0
    
    @State var listItem: ListItem
    @State var ImageCache = [String: UIImage]()
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .shadow(radius: 4)
                .frame(width: cardWidth, height: cardHeight)
                .foregroundColor(.white)
            if let key = listItem.ImageKey, let render = ImageCache[key] {
                VStack(alignment: .center) {
                    Image(uiImage: render)
                        .resizable()
                        .padding(.top)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: cardWidth, height: cardWidth)
                        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                    Spacer()
                    cardDetails
                        .padding(.horizontal)
                        .frame(width: cardWidth)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                }
                .frame(width: cardWidth, height: cardHeight)
            } else {
                
            }
            
        }
        .onAppear{
            getImage(Imagekey: listItem.ImageKey)
        }
    }
    
    var cardDetails: some View{
        VStack(alignment: .leading) {
            Text(listItem.Name)
                .font(.headline)
                .foregroundColor(.black)
                .padding(.top)
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
        } 
    }
}



//struct DisplayCards_Previews: PreviewProvider {
//    static var previews: some View {
//        DisplayCards()
//    }
//}
