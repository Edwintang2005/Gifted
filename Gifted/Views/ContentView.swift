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
