//
//  ContentView.swift
//  Gifted
//
//  Created by Edwin Tang on 3/12/2022.
//

import SwiftUI
import Amplify


// Window Post-login, includes a menu to navigate to friends tab
struct ContentView: View {
    
    @ObservedObject var dataStore = DataStore()
    @EnvironmentObject var sessionManager: SessionManager

    
    @State var ImageCache = [String: UIImage]()
    @State var lists = [UserList]()
    @State var listNumber = 0
    
    @State private var nameRecieved = false
    
    @State private var userProfile = UserProfile(Username: "NULL", Name: String())
    @AppStorage("NameOfUser") var NameOfUser: String = ""
    @AppStorage("Username") var Username: String = ""
    @AppStorage("UserID") var UserID: String = ""
    
   
    
    let user: AuthUser
    
    var body: some View {
        if nameRecieved {
            TabView {
                MainView(ImageCache: $ImageCache, lists: $lists)
                    .tabItem{
                        Label("Lists", systemImage: "list.bullet.rectangle.portrait")
                    }
                ItemSearchView(ImageCache: $ImageCache, lists: $lists, listNumber: $listNumber)
                    .tabItem{
                        Label("Explore", systemImage: "magnifyingglass")
                    }
                
                SocialView(ImageCache: $ImageCache)
                    .tabItem{
                        Label("Socials", systemImage: "person.2")
                    }
            }
            .tint(Color(.sRGB, red: 37/255, green: 75/255, blue: 72/255))
            .onAppear{
                getLists()
                if lists.count == 0 {
                    dataStore.createFirstList(userID: UserID, name: NameOfUser)
                }
            }
        } else {
            VStack(alignment: .center) {
                Text("Welcome to").boldText()
                Text("Gifted").colourGradient()
            }
            .onAppear{
                getAttributes()
                getLists()
                if lists.count == 0 {
                    dataStore.createFirstList(userID: UserID, name: NameOfUser)
                }
            }
        }
    }
    
    func getAttributes() {
        if NameOfUser == "" {
            do {
                Amplify.Auth.fetchUserAttributes() { result in
                    switch result {
                    case .success(let attributes):
                        let name = attributes.filter {$0.key == .name}
                        NameOfUser = name.first?.value ?? ""
                    case .failure(let error):
                        print("Fetching user attributes failed with error \(error)")
                    }
                }
            }
            
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
            nameRecieved = true
        } else {
            nameRecieved = true
        }
        
        
        
    }
    
    func getLists() {
        lists = dataStore.fetchLists(userID: UserID)
        
    }
}



//struct ContentView_Previews: PreviewProvider {
//    private struct DummyUser: AuthUser {
//        let userId: String = "1"
//        let username: String = "dummy"
//    }
//
//    static var previews: some View {
//        ContentView(user: DummyUser())
//    }
//}
