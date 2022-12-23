//
//  ItemSearchView.swift
//  Gifted
//
//  Created by Edwin Tang on 23/12/2022.
//

import SwiftUI
import Amplify

struct ItemSearchView: View {
    
    @State var listitems = [ListItem]()
    @Binding var ImageCache : [String: UIImage]
    @State private var searchedText = ""
    @State var QueryUsername = UserDefaults.standard.string(forKey: "Username") ?? "NullUser"
    
    var listitemsFiltered: [ListItem] {
        if searchedText.isEmpty {
            return listitems
        } else {
            return listitems.filter { $0.Name.contains(searchedText)}
        }
    }
    
    var body: some View {
        VStack {
            List{
                ForEach(listitemsFiltered) {
                    Item in NavigationLink{
                        if let key = Item.ImageKey {
                            ItemDetailsView(listItem: Item, ImageRender: ImageCache[key], QueryUsername: $QueryUsername)
                        } else {
                            ItemDetailsView(listItem: Item, QueryUsername: $QueryUsername)
                        }
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
                                Text(Item.Name).listtext()
                                Text("$ \(Item.Price ?? "No PRICE ATTATCHED")").small()
                            }
                            .padding(.horizontal)
                            Spacer()
                        }.onAppear{getImage(Imagekey: Item.ImageKey)}
                    }
                }
            }
            
        }
        .onAppear{
            getListItem()
        }
        .navigationBarTitle("Find Items to Add")
        .searchable(text: $searchedText)
        .navigationBarItems(trailing: (
            HStack{
                Button(action: {
                    getListItem()
                }) {
                    Image(systemName: "arrow.clockwise")
                        .imageScale(.large)
                }
                NavigationLink{
                    AddToList()
                } label: {
                    Image(systemName: "plus")
                        .imageScale(.large)
                }
            }
        ))
    }
    
    // Function that queries database and retrieves all list items
    func getListItem() {
        Amplify.DataStore.query(ListItem.self) { result in
            switch result {
            case.success(let listitems):
                self.listitems = listitems
            case.failure(let error):
                print(error)
            }
        }
    }
    
    // Function that loads the images for the icons (Same as in ListView)
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


// Preview Simulator code, ignore

//struct ItemSearchView_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemSearchView()
//    }
//}
