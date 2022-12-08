//
//  ItemDetailsView.swift
//  Gifted
//
//  Created by Edwin Tang on 3/12/2022.
//

import SwiftUI
import Amplify

// UI for displaying the details of a list item
struct ItemDetailsView: View {
    
    @State var ImageRender: UIImage?
    
    let listItem : ListItem
    
    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 40) {
                // Image of item, contains logic to display a replacement image if no image is attatched
                if let Render = ImageRender {
                    Image(uiImage: Render)
                        .renderingMode(.original)
                        .resizable()
                        .padding(.vertical)
                        .aspectRatio(contentMode: .fit)
                        .mask { RoundedRectangle(cornerRadius: 4, style: .continuous) }
                } else {
                    Image("ImageNotFound")
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .mask { RoundedRectangle(cornerRadius: 4, style: .continuous) }
                }
            }
            .padding(.all)
            // Overlay of image to represent people who have reserved the item, No actual logic or data structure attatched to this yet
            .overlay(alignment: .topTrailing) {
                HStack {
                    Image(systemName: "a.circle.fill")
                        .imageScale(.large)
                }
                .font(.title3)
                .padding(.horizontal)
            }
            
            // The Small amount of information displayed below the image
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text(listItem.Link ?? " ") // Item link as inputted by user
                        .font(.subheadline.weight(.medium))
                        .lineLimit(2)
                    Text(listItem.ShortDescription ?? " ") // Item Description as inputted by user
                        .font(.headline.weight(.medium))
                        .lineLimit(2)
                        .foregroundColor(.secondary)
                }
                Spacer()
                Text("$" + (listItem.Price ?? " ")) // Item Price as inputted by user
                    .font(.body)
                    .foregroundColor(.primary)
            }
                .padding(.horizontal)
            Spacer()
            // Button for reserving purchase (Should verify and hide if the user viewing item is owner) -> Consider changing button design
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
            .navigationTitle(listItem.Name ?? " ")
            .onAppear{getImage(Imagekey: listItem.ImageKey)}
    }
    
    // Function for fetching image to display
    func getImage(Imagekey: String?) {
        guard let Key = Imagekey else {return}
        Amplify.Storage.downloadData(key: Key) { result in
            switch result {
            case .success(let ImageData):
                print("Fetched ImageData")
                let image = UIImage(data: ImageData)
                DispatchQueue.main.async{
                    ImageRender = image
                }
                return
            case .failure(let error):
                print("Could not get Image URL - \(error)")
            }
        }
    }
}



//struct ItemDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemDetailsView()
//    }
//}
