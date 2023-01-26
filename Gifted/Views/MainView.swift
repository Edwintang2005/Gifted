//
//  MainView.swift
//  Gifted
//
//  Created by Edwin Tang on 31/12/2022.
//

import SwiftUI
import Amplify

// Object for the Main view or what is essentially our home screen
struct MainView: View {
    
    @ObservedObject var dataStore = DataStore()
    @EnvironmentObject var sessionManager: SessionManager
    
    @Binding var ImageCache: [String: UIImage]
    @Binding var lists: [UserList]
    @State var listitems = [ListItem]()
    
    var listitemsLength = Int()
    
    @State var listNumber = 0
   
    
    
    // Variable for User credentials for use throughout the app
    let UserID = UserDefaults.standard.string(forKey: "UserID") ?? "NullUser"
    let NameOfUser = UserDefaults.standard.string(forKey: "NameOfUser") ?? ""
    
    private let adaptiveColumns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    @State private var DisplayWelcome = true
    @State private var sortOption = 0
    @State private var ViewSelection = 0
    
    var body: some View{
        NavigationView {
            VStack{
                if DisplayWelcome {
                    HStack (alignment: .top) {
                        // Text that displays the User's name
                        NavigationLink{
                            SettingsView(ImageCache: $ImageCache)
                        } label: {
                            Text("Welcome back, \n\(NameOfUser)!")
                                .colourGradient()
                        }
                        Spacer()
                    }
                    .padding(.bottom)
                    HStack {
                        Text("Wishlist")
                            .subtitle()
                        Spacer()
                    }
                } else {
                    HStack {
                        Text("Wishlist")
                            .colourGradient()
                        Spacer()
                        NavigationLink{
                            SettingsView(ImageCache: $ImageCache)
                        } label: {
                            Image(systemName: "person.circle")
                                .imageScale(.large)
                        }
                    }
                }
                
                HStack {
                    Picker("Display format", selection: $ViewSelection) {
                        Image(systemName: "square.grid.2x2")
                            .tag(0)
                        Image(systemName: "rectangle.grid.1x2")
                            .tag(1)
                    }
                    .labelsHidden()
                    .pickerStyle(.segmented)
                    .fixedSize()
                    Menu {
                        Button {
                            sortOption = 0
                        } label: {
                            if sortOption == 0 {
                                Image(systemName: "checkmark")
                                Text("Name")
                            } else {
                                Text("Name")
                            }
                            
                        }
                        Button {
                            sortOption = 1
                        } label: {
                            if sortOption == 1 {
                                Image(systemName: "checkmark")
                                Text("Time")
                            } else {
                                Text("Time")
                            }
                        }
                        Button {
                            sortOption = 2
                        } label: {
                            if sortOption == 2 {
                                Image(systemName: "checkmark")
                                Text("Price")
                            } else {
                                Text("Price")
                            }
                        }
                    } label: {
                        Image(systemName: "arrow.up.arrow.down")
                    }
                    Spacer()
                    NavigationLink{
                        AddToList(lists: $lists, listNumber: $listNumber)
                    } label: {
                        Image(systemName: "plus")
                            .imageScale(.large)
                    }
                }
                
                if lists.count == 0 {
                    Text("An error occurred, please restart the app")
                } else if listitems.count == 0 {
                    Spacer()
                    Text("Welcome to the app! \n Hop over to the Explore page to add items.")
                        .multilineTextAlignment(.center)
                    Spacer()
                } else {
                    ScrollView(showsIndicators: false) {
                        if ViewSelection == 0 {
                            LazyVGrid(columns: adaptiveColumns) {
                                ForEach(listitems) { item in
                                    NavigationLink{
                                        if let key = item.ImageKey {
                                            ItemDetailsView(list: $lists[listNumber], listItem: item, ImageRender: ImageCache[key])
                                        } else {
                                            ItemDetailsView(list: $lists[listNumber], listItem: item)
                                        }
                                    } label: {
                                        DisplayCards(listItem: item, ImageCache: $ImageCache)
                                    }
                                }
                            }
                        } else {
                            ForEach(listitems) { item in
                                NavigationLink{
                                    if let key = item.ImageKey {
                                        ItemDetailsView(list: $lists[listNumber], listItem: item, ImageRender: ImageCache[key])
                                    } else {
                                        ItemDetailsView(list: $lists[listNumber], listItem: item)
                                    }
                                } label: {
                                    HorizontalDisplayCards(listItem: item, ImageCache: $ImageCache)
                                }
                            }
                        }
                    }
                    .padding(.top)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal)
            .onAppear{
                getListItem()
                DispatchQueue.main.asyncAfter(deadline: .now() + 7.5) {
                    withAnimation{
                        DisplayWelcome = false
                    }
                }
            }
        }
    }
    
    func getImage(Imagekey: String?) {
        guard let Key = Imagekey else {return}
        if ImageCache.keys.contains(Key) {
            return
        } else {
            let fetchedImage = dataStore.getImage(ImageKey: Key)
            if fetchedImage != UIImage() {
                DispatchQueue.main.async{
                    ImageCache[Key] = fetchedImage
                }
            }
        }
    }
    
    
    func getListItem() {
        listitems = dataStore.fetchListItems(listid: lists[listNumber].id)
    }
}




//struct MainView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainView()
//    }
//}
