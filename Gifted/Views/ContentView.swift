//
//  ContentView.swift
//  Gifted
//
//  Created by Edwin Tang on 3/12/2022.
//

import SwiftUI
import Amplify
import AWSPluginsCore
import AWSCognitoIdentityProvider




// Window Post-login, includes a menu to navigate to friends tab
struct ContentView: View {
    
    @EnvironmentObject var menuViewController: MenuViewController
    @EnvironmentObject var sessionManager: SessionManager
    
    
    
    @State var ShowMenu = false
    
    let userID = UserDefaults.standard.string(forKey: "UserID") ?? "NullUser"
    let username = UserDefaults.standard.string(forKey: "Username") ?? "NullUser"
    let user: AuthUser
    
    var body: some View {
        
        // Animations for showing and hiding the menu
        let drag = DragGesture()
                    .onEnded {
                        if $0.translation.width < -60 {
                            withAnimation {
                                self.ShowMenu = false
                            }
                        }
                        if $0.translation.width > 60 {
                            withAnimation{
                                self.ShowMenu = true
                            }
                        }
                    }
        
        // The function that causes the display of both the Home page and the Menu
        return NavigationView {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    switch self.menuViewController.menuDisplay {
                        
                    case .mainWindow:
                        MainView()
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .offset(x: ShowMenu ? geometry.size.width/2 : 0)
                            .disabled( ShowMenu ? true : false)
                        
                    case .list:
                        ListView(QueryID: userID)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .offset(x: ShowMenu ? geometry.size.width/2 : 0)
                            .disabled( ShowMenu ? true : false)
                        
                    case .friends:
                        FriendsView()
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .offset(x: ShowMenu ? geometry.size.width/2 : 0)
                            .disabled( ShowMenu ? true : false)
                        
                    case .groups:
                        GroupsView()
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .offset(x: ShowMenu ? geometry.size.width/2 : 0)
                            .disabled( ShowMenu ? true : false)
                    }
                    if self.ShowMenu {
                        MenuView(ShowMenu: self.$ShowMenu)
                            .frame(width: geometry.size.width/2)
                            .transition(.move(edge: .leading))
                    }
                }
                .gesture(drag)
            }
            .navigationBarItems(leading: (
                Button(action: {
                    withAnimation {
                        self.ShowMenu.toggle()
                    }
                }) {
                    Image(systemName: "line.horizontal.3")
                        .imageScale(.large)
                }
            ))
        }
        .onAppear{
            menuViewController.showMain()
        }
    }
}

// Object for the Main view or what is essentially our home screen
struct MainView: View {
    
    @ObservedObject var dataStore = DataStore()
    
    @EnvironmentObject var sessionManager: SessionManager
    
    @State private var userProfile = User(Username: "NULL")
    @State private var NameOfUser = ""
    @State var ImageCache = [String: UIImage]()
    
    // Variable for storing the User's username for use throughout the app
    @AppStorage("Username") var Username: String = ""
    @AppStorage("UserID") var UserID: String = ""
    
    var body: some View{
        VStack(spacing: 50) {
            HStack {
                // Text that displays the User's name
                Text("Hello, \(NameOfUser)!").homepagename()
                Spacer()
            }
            // replace below with Roger's design of Homescreen
            Spacer()
        }
        .padding()
        .navigationBarTitle("Home")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: (
            Button("Sign Out", action: sessionManager.signOut)
        ))
        .onAppear{
            fetchUserInfo()
        }
    }
    
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
                dataStore.createUser(userID: UserID, username: Username)
            } else {
                print(userObject)
                userProfile = userObject
            }
        }
    }
}



// Object for the popup menu
struct MenuView: View{
    
    @EnvironmentObject var menuViewController: MenuViewController
    @EnvironmentObject var sessionManager: SessionManager
    
    @Binding var ShowMenu: Bool
    
    let username = UserDefaults.standard.string(forKey: "Username") ?? "NullUser"
    
    var body: some View{
        VStack{
            // Menu Feature to navigate to Home Page
            Button {
                menuViewController.showMain()
                animateCollapse()
            } label: {
                HStack{
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            }
            .padding(.all)
            
            // Menu Feature to access user's list
            Button {
                menuViewController.showList()
                animateCollapse()
            } label: {
                HStack{
                    Image(systemName: "list.bullet.rectangle")
                    Text("My List")
                }
            }
            .padding(.all)
            // Menu Feature to access user's friends
            Button {
                menuViewController.showFriends()
                animateCollapse()
            } label: {
                HStack{
                    Image(systemName: "person.2.fill")
                    Text("Friends")
                }
            }
            .padding(.all)
            // Menu Feature to access user's groups
            Button {
                menuViewController.showGroups()
                animateCollapse()
            } label: {
                HStack{
                    Image(systemName: "person.3.sequence.fill")
                    Text("Groups")
                }
            }
            .padding(.all)
            Spacer()
        }
    }
    
    // For animating the dissapearance of menu
    func animateCollapse() {
        withAnimation {
            self.ShowMenu = false
        }
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
