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
    
    
    @Environment(\.openURL) var openURL
    @ObservedObject var dataStore = DataStore()
    
    // Variables passed into view
    @Binding var list : UserList
    @State var listItem : ListItem
    @State var ImageRender: UIImage?

    
    let userID = UserDefaults.standard.string(forKey: "UserID") ?? "NullUser"
    let cardWidth = UIScreen.main.bounds.size.width * 3/4
    let cardHeight = UIScreen.main.bounds.size.height * 3/5
    let cornerRadius = 7.0
    
    // Variables for View functionality
    @State var addedToList = Bool()
    @State var selfQuery = Bool()
    @State var Reserved = Bool()
    
    var body: some View {
        VStack{
            ZStack {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .cardBackgroundandShadow(cornerRadius: cornerRadius)
                    .frame(width: cardWidth, height: cardHeight)
                VStack {
                    Text(listItem.Name)
                        .boldText()
                        .padding(.top)
                        .multilineTextAlignment(.center)
                    VStack {
                        // Image of item, contains logic to display a replacement image if no image is attatched
                        if let Render = ImageRender {
                            Image(uiImage: Render)
                                .renderingMode(.original)
                                .resizable()
                                .padding(.vertical)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: cardWidth, height: cardWidth)
                        } else {
                            Image("ImageNotFound")
                                .renderingMode(.original)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .mask { RoundedRectangle(cornerRadius: 4, style: .continuous) }
                        }
                    }
                    .padding(.all)
                    Divider()
                    // Information displayed below the image
                    VStack(alignment: .leading) {
                        Text("$" + (listItem.Price ?? " ")) // Item Price as inputted by user
                            .font(.body)
                            .foregroundColor(.primary)
                    }
                    Spacer()
                }
                .frame(width: cardWidth, height: cardHeight)
                .padding(.all)
            }
            // Buttons below details
            HStack(alignment: .center) {
                if let link = URL(string: listItem.Link ?? "") {
                    Button {
                        openURL(link)
                    } label: {
                        Text("Buy Online")
                    }
                    .pretty()
                }
                if selfQuery == true {
                    // Owner User querying, hence add to list or remove from list
                    Spacer()
                    if addedToList {
                        Button {
                            deleteFromList()
                        } label: {
                            Text("Delete Item")
                        }
                        .pretty()
                    } else {
                        Button {
                            addToList()
                        } label: {
                            Text("Add Item")
                        }
                        .pretty()
                    }
                } else {
                    // Not self is querying, hence reserve or remove reservation
                    Spacer()
                    if Reserved == true {
                        Button {
                            unreserveItem()
                        } label: {
                            Text("Unreservation")
                        }
                        .pretty()
                    } else {
                        Button {
                            reserveItem()
                        } label: {
                            Text("Reserve")
                        }
                        .pretty()
                    }
                }
            }
            .padding(.all)
        }
        .onAppear{
            refreshList()
            DetermineButton()
        }
    }
    
    // Function for checking if user is looking at their own list and determining button displayed
    func DetermineButton() {
        if userID == list.userID {
            selfQuery = true
            let listItems = dataStore.fetchListItems(listid: list.id)
            if listItems.contains(listItem) {
                addedToList = true
            } else {
                addedToList = false
            }
        } else {
            selfQuery = false
            checkReservation()
        }
    }
    
    func checkReservation() {
        Reserved = false
        //        guard let reservationList = listItem.Reservation else {return}
        //        if reservationList.contains(username) {
        //            Reserved = true
        //        } else {
        //            Reserved = false
        //        }
    }
    
    func addToList() {
        dataStore.changeLists(action: .addTo, list: list, change: listItem)
        refreshList()
        DetermineButton()
    }
    
    func deleteFromList() {
        // Removing item from User's List
        dataStore.changeLists(action: .removeFrom, list: list, change: listItem)
        refreshList()
        DetermineButton()
    }
    
    // Function for fetching image to display
    func getImage(Imagekey: String?) {
        guard let Key = Imagekey else {return}
        let fetchedImage = dataStore.getImage(ImageKey: Key)
        if fetchedImage != UIImage() {
            DispatchQueue.main.async{
                ImageRender = fetchedImage
            }
        }
    }
    
    func reserveItem() {
        print("Button Pressed!")
        // Dud reserve Item function, need to redo
        
        //        Amplify.DataStore.query(ListItem.self, byId: listItem.id) { result in
        //            switch result {
        //            case .success(let Item):
        //                guard var item = Item else {return}
        //                var reservedByList = item.Reservation
        //                reservedByList?.append(username)
        //                item.Reservation = reservedByList
        //                Amplify.DataStore.save(item) {results in
        //                    switch results {
        //                    case .success:
        //                        print("Reserved!")
        //                    case .failure(let error):
        //                        print("Could not reserve Item - \(error)")
        //                    }
        //
        //                }
        //            case .failure(let error):
        //                print("Could not Reserve Item - \(error)")
        //            }
        //        }
        refreshList()
        DetermineButton()
    }
    
    func unreserveItem() {
        print("Button Pressed!")
        // Dud unreserve Item function, need to redo
        
        //        Amplify.DataStore.query(ListItem.self, byId: listItem.id) { result in
        //            switch result {
        //            case .success(let Item):
        //                guard var item = Item else {return}
        //                var reservedByList = item.Reservation
        //                reservedByList?.removeAll{$0 == username}
        //                item.Reservation = reservedByList
        //                Amplify.DataStore.save(item) {results in
        //                    switch results {
        //                    case .success:
        //                        print("Unreserved!")
        //                    case .failure(let error):
        //                        print("Could not remove reservation - \(error)")
        //                    }
        //
        //                }
        //            case .failure(let error):
        //                print("Could not Unreserve Item - \(error)")
        //            }
        //        }
        refreshList()
        DetermineButton()
    }
    
    func refreshList() {
        list = dataStore.refreshList(listID: list.id)
    }
}



//struct ItemDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemDetailsView()
//    }
//}
