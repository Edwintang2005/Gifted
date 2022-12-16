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
    
    @EnvironmentObject var sessionManager: SessionManager
    
    @State var ShowMenu = false
    
    let user: AuthUser
    
    var body: some View {
        
        // Animations for showing and hiding the menu
        let drag = DragGesture()
                    .onEnded {
                        if $0.translation.width < -100 {
                            withAnimation {
                                self.ShowMenu = false
                            }
                        }
                        if $0.translation.width > 100 {
                            withAnimation{
                                self.ShowMenu = true
                            }
                        }
                    }
        
        // The function that causes the display of both the Home page and the Menu
        return NavigationView {
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            MainView(ShowMenu: self.$ShowMenu)
                                .frame(width: geometry.size.width, height: geometry.size.height)
                                .offset(x: self.ShowMenu ? geometry.size.width/2 : 0)
                                .disabled(self.ShowMenu ? true : false)
                            if self.ShowMenu {
                                MenuView()
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
    }
}

// Object for the Main view or what is essentially our home screen
struct MainView: View{
    
    @EnvironmentObject var sessionManager: SessionManager
    
    @State var listitems = [ListItem]()
    @State var Groups = [GroupLink]()
    @State var ImageCache = [String: UIImage]()
    let username = UserDefaults.standard.string(forKey: "Username") ?? "NullUser"
    
    //Variable for whether or not to show the menu
    @Binding var ShowMenu: Bool
    
    
    var body: some View{
        VStack(spacing: 50) {
            HStack {
                // Text that displays the User's name
                Text("Hello, \(username)!").homepagename()
                Spacer()
                Button("Sign Out", action: sessionManager.signOut)
            }
            // replace below with Roger's design of Homescreen
            List {
                Section {
                    Text("Your Items:")
                    ForEach(listitems) {
                        Item in NavigationLink{
                            ItemDetailsView(QueryUsername: username, listItem: Item)
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
                    Text("Your Groups:")
                    ForEach(Groups) {
                        Group in Text(Group.GroupName )
                    }
                } header: {
                    Text("Preview your Items and Groups!")
                }
                
            }
        }
        .padding()
        .navigationBarTitle("Home")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear{ // Basically hides the menu everytime the homescreen is displayed
            getListItem()
            getGroups()
            ShowMenu = false
        }
    }
    
    func getListItem() {
        let ListObj = ListItem.keys
        Amplify.DataStore.query(ListItem.self, where: ListObj.userID == username) { result in
            switch result {
            case.success(let listitems):
                print(listitems)
                self.listitems = listitems
            case.failure(let error):
                print(error)
            }
        }
    }
    
    func getGroups() {
        let username = UserDefaults.standard.string(forKey: "Username") ?? "NullUser"
        let GroupsLinkObj = GroupLink.keys
        Amplify.DataStore.query(GroupLink.self, where: GroupsLinkObj.OwnerUser == username) {result in
            switch result {
            case .success(let GroupsList):
                print(GroupsList)
                self.Groups = GroupsList
            case .failure(let error):
                print(error)
            }
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
}



// Object for the popup menu
struct MenuView: View{
    
    @EnvironmentObject var sessionManager: SessionManager
    let username = UserDefaults.standard.string(forKey: "Username") ?? "NullUser"
    
    var body: some View{
        VStack{
            
            // Menu Feature to access user's list
            NavigationLink(destination: ListView(QueryUsername: username)) {
                HStack{
                    Image(systemName: "list.bullet.rectangle")
                    Text("My List")
                }
            }
            .padding(.all)
            // Menu Feature to access user's friends
            NavigationLink(destination: FriendsView()) {
                HStack{
                    Image(systemName: "person.2.fill")
                    Text("Friends")
                }
            }
            .padding(.all)
            // Menu Feature to access user's groups
            NavigationLink(destination: GroupsView()) {
                HStack{
                    Image(systemName: "person.3.sequence.fill")
                    Text("Groups")
                }
            }
            .padding(.all)
            Spacer()
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
