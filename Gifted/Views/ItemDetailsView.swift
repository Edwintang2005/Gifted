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
    
    @ObservedObject var dataStore = DataStore()
    
    // Variables passed into view
    @Binding var list : UserList
    @State var listItem : ListItem
    @State var ImageRender: UIImage?
    @State var QueryID: String
    let username = UserDefaults.standard.string(forKey: "Username") ?? "NullUser"
    let userID = UserDefaults.standard.string(forKey: "UserID") ?? "NullUser"
    
    // Variables for View functionality
    @State var addedToList = Bool()
    @State var selfQuery = Bool()
    @State var Reserved = Bool()
    
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
            
            // Information displayed below the image
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    if let link = listItem.Link {
                        Link(listItem.Name,
                             destination: URL(string: link)!)
                        .font(.subheadline.weight(.medium))
                        .foregroundColor(Color.primary)
                    } // Item link as inputted by user
                    Text(listItem.ShortDescription ?? " ") // Item Description as inputted by user
                        .font(.headline.weight(.medium))
                        .foregroundColor(.secondary)
                    Spacer()
                }
                Spacer()
                VStack{
                    Text("$" + (listItem.Price ?? " ")) // Item Price as inputted by user
                        .font(.body)
                        .foregroundColor(.primary)
                    Spacer()
                }
            }
            .padding(.horizontal)
            // Buttons below details
            if selfQuery == true {
                // Owner User querying, hence add to list or remove from list
                Spacer()
                if addedToList {
                    Button {
                        deleteFromList()
                    } label: {
                        Text("Remove from List")
                    }
                    .pretty()
                } else {
                    Button {
                        addToList()
                    } label: {
                        Text("Add to List")
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
                        Text("Remove Reservation")
                    }
                    .pretty()
                } else {
                    Button {
                        reserveItem()
                    } label: {
                        Text("Reserve for purchase")
                    }
                    .pretty()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.vertical)
        .onAppear{
            DetermineButton()
        }
        .navigationTitle(listItem.Name)
        .navigationBarItems(trailing: (
            Button(action: {
                refreshItem()
                DetermineButton()
            }) {
                Image(systemName: "arrow.clockwise")
                    .imageScale(.large)
            }
        ))
    }
    
    // Function for checking if user is looking at their own list and determining button displayed
    func DetermineButton() {
        if QueryID == userID {
            selfQuery = true
            checkList()
        } else {
            selfQuery = false
            checkReservation()
        }
    }
    
    func checkList() {
        let listItems = dataStore.fetchListItems(listid: list.id)
        listItems.forEach{ item in
            if item.id == listItem.id {
                addedToList = true
            } else {
                addedToList = false
            }
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
        refreshItem()
        DetermineButton()
    }
    
    func deleteFromList() {
        // Removing item from User's List
        dataStore.changeLists(action: .removeFrom, list: list, change: listItem)
        refreshItem()
        DetermineButton()
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
        refreshItem()
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
        refreshItem()
        DetermineButton()
    }
    
    func refreshItem() {
        Amplify.DataStore.query(ListItem.self, byId: listItem.id) { result in
            switch result {
            case .success(let update):
                if let updatedItem = update {
                    listItem = updatedItem
                }
            case .failure(let error):
                print("Could not update item - \(error)")
            }
        }
        Amplify.DataStore.query(UserList.self, byId: list.id) { result in
            switch result {
            case .success(let update):
                if let updatedlist = update {
                    list = updatedlist
                }
            case .failure(let error):
                print("Could not update list - \(error)")
            }
        }
    }
}



//struct ItemDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemDetailsView()
//    }
//}
