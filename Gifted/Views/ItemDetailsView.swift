//
//  ItemDetailsView.swift
//  Gifted
//
//  Created by Edwin Tang on 3/12/2022.
//

import Amplify
import SwiftUI


// UI for displaying the details of a list item
struct ItemDetailsView: View {
    
    @State var QueryUsername: String
    @State var ImageRender: UIImage?
    @State var selfQuery = Bool()
    @State var Reserved = Bool()
    @State var username = UserDefaults.standard.string(forKey: "Username") ?? "NullUser"
    
    let listItem : ListItem
    
    var body: some View {
        VStack {
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
            // Button for reserving purchase -> Consider changing button design
            if selfQuery == true {
                Spacer()
            } else {
                if let reservations = listItem.Reservation{
                    List{
                        Section {
                            ForEach(reservations, id: \.self) {
                                Member in Text(Member).listtext()
                            }
                        } header: {
                            Text("These people reserved this item:")
                        }
                    }
                }
                Spacer()
                if Reserved == true {
                    Button {
                            unreserveItem()
                        }
                            label: {
                                    Text("Remove Reservation")
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
                } else {
                    Button {
                            reserveItem()
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
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.vertical)
        .navigationTitle(listItem.Name)
        .onAppear{
            checkUserIsSelf()
            checkReservation()
            getImage(Imagekey: listItem.ImageKey)
            }
    }
    
    // Function for checking if user is looking at their own list
    func checkUserIsSelf() {
        if QueryUsername == UserDefaults.standard.string(forKey: "Username") ?? "NullUser" {
            selfQuery = true
        } else {
            selfQuery = false
        }
    }
    
    func checkReservation() {
        Reserved = false
        guard let reservationList = listItem.Reservation else {return}
        if reservationList.contains(username) {
            Reserved = true
        } else {
            Reserved = false
        }
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
    
    func reserveItem() {
        Amplify.DataStore.query(ListItem.self, byId: listItem.id) { result in
            switch result {
            case .success(let Item):
                guard var item = Item else {return}
                var reservedByList = item.Reservation
                reservedByList?.append(username)
                item.Reservation = reservedByList
                Amplify.DataStore.save(item) {results in
                    switch results {
                    case .success:
                        print("Reserved!")
                    case .failure(let error):
                        print("Could not reserve Item - \(error)")
                    }
                    
                }
            case .failure(let error):
                print("Could not Reserve Item - \(error)")
            }
        }
    }
    
    func unreserveItem() {
        Amplify.DataStore.query(ListItem.self, byId: listItem.id) { result in
            switch result {
            case .success(let Item):
                guard var item = Item else {return}
                var reservedByList = item.Reservation
                reservedByList?.removeAll{$0 == username}
                item.Reservation = reservedByList
                Amplify.DataStore.save(item) {results in
                    switch results {
                    case .success:
                        print("Unreserved!")
                    case .failure(let error):
                        print("Could not remove reservation - \(error)")
                    }
                    
                }
            case .failure(let error):
                print("Could not Unreserve Item - \(error)")
            }
        }
    }
}



//struct ItemDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemDetailsView()
//    }
//}
