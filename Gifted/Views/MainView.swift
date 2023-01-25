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
    
    @State private var userProfile = UserProfile(Username: "NULL", Name: String())
    
    @State var listitems = [ListItem]()
    var listitemsLength = Int()
    @State var ImageCache = [String: UIImage]()
    
    @AppStorage("NameOfUser") var NameOfUser: String = ""
    
    // Variable for storing the User's username for use throughout the app
    @AppStorage("Username") var Username: String = ""
    @AppStorage("UserID") var UserID: String = ""
    
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
                        Text("Welcome back, \n\(NameOfUser)!")
                            .colourGradient()
                            .font(.largeTitle)
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
                            .font(.largeTitle)
                        Spacer()
                    }
                }
                
                HStack {
                    Spacer()
                    Text("Sort By: ")
                    Picker("Sort by", selection: $sortOption) {
                        Text("Name").tag(0)
                        Text("Time").tag(1)
                        Text("Price").tag(2)
                    }
                    Picker("Display format", selection: $ViewSelection) {
                        Image(systemName: "square.grid.2x2")
                            .tag(0)
                        Image(systemName: "rectangle.grid.1x2")
                            .tag(1)
                    }
                    .pickerStyle(.segmented)
                }
                ScrollView(showsIndicators: false) {
                    if ViewSelection == 0 {
                        LazyVGrid(columns: adaptiveColumns) {
                            ForEach(listitems) { item in
                                DisplayCards(listItem: item, ImageCache: $ImageCache)
                                    .padding(.all)
                            }
                        }
                    } else {
                        ForEach(listitems) { item in
                            HorizontalDisplayCards(listItem: item, ImageCache: $ImageCache)
                                .padding(.all)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal)
            .onAppear{
                fetchUserInfo()
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
        let fetchedImage = dataStore.getImage(ImageKey: Key)
        if fetchedImage != UIImage() {
            DispatchQueue.main.async{
                ImageCache[Key] = fetchedImage
            }
        }
    }
    
    
    func fetchUserInfo() {
        Amplify.Auth.fetchUserAttributes() { result in
            switch result {
            case .success(let attributes):
                let name = attributes.filter {$0.key == .name}
                NameOfUser = name.first?.value ?? ""
            case .failure(let error):
                print("Fetching user attributes failed with error \(error)")
            }
        }
        
        //Get Username and create/check for user object - need to resolve occassional query return empty issue
        
        if let user = Amplify.Auth.getCurrentUser() {
            Username = user.username
            UserID = user.userId
            print(Username)
            
            let userObject = dataStore.fetchUser(userID: UserID)
            if userObject.Username == "NULL" {
                dataStore.createUser(userID: UserID, username: Username, nameofUser: NameOfUser)
            } else {
                print(userObject)
                userProfile = userObject
            }
        }
    }
    
    func getListItem() {
        listitems = dataStore.allItemsQuery()
    }
}




//struct MainView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainView()
//    }
//}
