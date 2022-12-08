//
//  ListView.swift
//  Gifted
//
//  Created by Edwin Tang on 4/12/2022.
//

import Amplify
import Combine
import SwiftUI

// Main window to display every list item
struct ListView: View {
    @EnvironmentObject var sessionManager: SessionManager
    
    @State var listitems = [ListItem]()
    @State var observationToken: AnyCancellable?
    @State var ImageCache = [String: UIImage]()
    @State var ListLength = Int()
    
    var body: some View {
        ZStack {
            
            if ListLength == 0 {
                VStack{
                    Spacer()
                    Text("You have No List Items! 😢").large()
                    Spacer()
                    Text("Why don't we start by adding an item using the + button!").large()
                    Spacer()
                }
            } else {
                // Code that takes retrieved list and displays each item seperately
                List {
                    ForEach(listitems) {
                        Item in NavigationLink{
                            ItemDetailsView(listItem: Item)
                        } label: {
                            HStack{
                                // Small Icon Image Rendering
                                if let key = Item.ImageKey {
                                    if let Render = ImageCache[key] {
                                        Image(uiImage: Render).Icon()
                                    } else {
                                        Image("ImageNotFound").Icon()
                                    }
                                } else {
                                    Image("ImageNotFound").Icon()
                                }
                                
                                VStack(alignment: .leading) {
                                    Text(Item.Name ?? " ").listtext()
                                    Text("$ \(Item.Price ?? "No PRICE ATTATCHED")").small()
                                }
                                .padding(.horizontal)
                                Spacer()
                            }.onAppear{getImage(Imagekey: Item.ImageKey)}
                            
                        }
                    }
                    .onDelete(perform: deleteItem)
                }
            }
            // Structure that holds + button and pushes it to bottom right corner
            VStack{
                Spacer()
                HStack{
                    Spacer()
                    NavigationLink{
                        AddToList()
                    } label: {
                            Image(systemName: "plus.circle.fill").floaty()
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarTitle("My List")
        .onAppear{
            getListItem()
            ListLength = listitems.count
            //observeListItem()
        }
    }
    
    // Function that queries database and retrieves any list items created by the user
    func getListItem() {
        let username = UserDefaults.standard.string(forKey: "Username")
        let ListObj = ListItem.keys
        guard let name = username else {return}
        Amplify.DataStore.query(ListItem.self, where: ListObj.userID == name) { result in
            switch result {
            case.success(let listitems):
                print(listitems)
                self.listitems = listitems
            case.failure(let error):
                print(error)
            }
        }
    }
    
    
    // Need to research the necessity of this function, perhaps comes in later???
//    func observeListItem() {
//        let too = ListItem.keys
//        observationToken = Amplify.DataStore.publisher(for: ListItem.self).sink(
//            receiveCompletion: { completion in
//                if case .failure(let error) = completion {
//                    print(error)
//                }
//            },
//            receiveValue: { changes in
//                // decoding recieved model
//                guard let item = try? changes.decodeModel(as: ListItem.self) else {return}
//
//                switch changes.mutationType{
//
//                case "create":
//                    self.listitems.append(item)
//
//                case "delete":
//                    if let index = self.listitems.firstIndex(of: item) {
//                        self.listitems.remove(at: index)
//                    }
//                default:
//                    break
//                }
//                
//            }
//
//        )
//
//    }
    
    
    // Function that deletes an item when the user clicks on the delete button
    func deleteItem(indexSet: IndexSet) {
        print("Deleted item at \(indexSet)")
        
        var updatedItems = listitems
        updatedItems.remove(atOffsets: indexSet)
        
        guard let item = Set(updatedItems).symmetricDifference(listitems).first else {return}
        
        Amplify.DataStore.delete(item) { result in
            switch result {
            case .success:
                print("Deleted Item")
            case .failure(let error):
                print("could not delete Item - \(error)")
            }
        }
        deleteImage(Imagekey: item.ImageKey)
    }
    
    // Function that deletes the image from the database alongside the deletion of the item
    func deleteImage( Imagekey: String?) {
        guard let Key = Imagekey else {return}
        Amplify.Storage.remove(key: Key) {result in
            switch result {
            case .success:
                print("Deleted Image")
            case .failure(let error):
                print("could not delete Image - \(error)")
            }
        }
    }
    
    // Function that loads the images for the icons (Same as in ItemDetailsView)
    func getImage(Imagekey: String?) {
        guard let Key = Imagekey else {return}
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

    
    // Function that basically stops displaying list items that don't belong to the user, however could be useful in future

//    func filterItem(listed: [ListItem]) -> [ListItem] {
//        return listed.filter {Item in
//            Item.userID == UserDefaults.standard.string(forKey: "Username")
//        }
//    }
}



//struct ListView_Previews: PreviewProvider {
//    static var previews: some View {
//        ListView()
//    }
//}
