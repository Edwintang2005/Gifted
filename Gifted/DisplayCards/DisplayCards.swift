//
//  DisplayCards.swift
//  Gifted
//
//  Created by Edwin Tang on 31/12/2022.
//

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
            if let key = listItem.ImageKey{
                VStack(alignment: .leading) {
                    Image(key)
                        .resizable()
                        .padding(.bottom)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: cardWidth, height: cardHeight*9/10)
                        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                    Spacer()
                    cardDetails
                        .padding(.trailing)
                        .frame(width: cardWidth)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                }
                .border(.gray)
                .padding()
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
