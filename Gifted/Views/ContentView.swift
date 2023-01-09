//
//  ContentView.swift
//  Gifted
//
//  Created by Edwin Tang on 3/12/2022.
//

import SwiftUI




// Window Post-login, includes a menu to navigate to friends tab
struct ContentView: View {
    
    @EnvironmentObject var menuViewController: MenuViewController
    
    
    @State var opacity = 1.0
    //    @State var ShowMenu = false {
    //        didSet{
    //            adjustOpacity() // Code that adjust opacity as ShowMenu changes
    //        }
    //    }
    
    let userID = UserDefaults.standard.string(forKey: "UserID") ?? "NullUser"
    
    
    var body: some View {
        TabView {
            MainView()
                .tabItem{
                    Label("Home", systemImage: "house")
                }
            ListView(QueryID: userID)
                .tabItem{
                    Label("Lists", systemImage: "list.bullet.clipboard")
                }
            SocialView()
                .tabItem{
                    Label("Social", systemImage: "person.3.sequence")
                }
        }
    }
}
        
//        // Animations for showing and hiding the menu
//        let drag = DragGesture()
//                    .onEnded {
//                        if $0.translation.width < -60 {
//                            withAnimation {
//                                ShowMenu = false
//                            }
//                        }
//                        if $0.translation.width > 60 {
//                            withAnimation{
//                                ShowMenu = true
//                            }
//                        }
//                    }
//
//        // The function that causes the display of both the Home page and the Menu
//        return NavigationView {
//            GeometryReader { geometry in
//                HStack {
//                    if self.ShowMenu {
//                        MenuView(opacity: $opacity,ShowMenu: $ShowMenu)
//                            .frame(width: geometry.size.width/2)
//                            .transition(.move(edge: .leading))
//                    }
//
//                    Divider()
//
//                    switch self.menuViewController.menuDisplay {
//
//                    case .mainWindow:
//                        MainView()
//                            .frame(width: geometry.size.width, height: geometry.size.height)
//                            .disabled( ShowMenu ? true : false)
//                            .opacity(opacity)
//
//                    case .list:
//                        ListView(QueryID: userID)
//                            .frame(width: geometry.size.width, height: geometry.size.height)
//                            .disabled( ShowMenu ? true : false)
//                            .opacity(opacity)
//
//                    case .friends:
//                        FriendsView()
//                            .frame(width: geometry.size.width, height: geometry.size.height)
//                            .disabled( ShowMenu ? true : false)
//                            .opacity(opacity)
//
//                    case .groups:
//                        GroupsView()
//                            .frame(width: geometry.size.width, height: geometry.size.height)
//                            .disabled( ShowMenu ? true : false)
//                            .opacity(opacity)
//                    }
//                }
//                .gesture(drag)
//            }
//            .navigationBarItems(leading: (
//                Button(action: {
//                    withAnimation {
//                        ShowMenu.toggle()
//                    }
//                }) {
//                    Image(systemName: "line.horizontal.3")
//                        .imageScale(.large)
//                }
//            ))
//        }
//        .onAppear{
//            menuViewController.showMain()
//        }
//    }
    
    // function for adjusting opacity
//    private func adjustOpacity() {
//        if ShowMenu {
//            opacity = 0.6
//        } else {
//            opacity = 1.0
//        }
//    }


// Object for the popup menu
//struct MenuView: View{
//
//    @EnvironmentObject var menuViewController: MenuViewController
//    @EnvironmentObject var sessionManager: SessionManager
//
//    // Variables passed from ContentView
//    @Binding var opacity: Double
//    @Binding var ShowMenu: Bool {
//        didSet{
//            adjustOpacity() // Code that adjusts Opacity of ContentView as ShowMenu changes
//        }
//    }
//
//    var body: some View{
//        ZStack{
//            Rectangle()
//                .foregroundColor(Color(.systemBackground))
//            VStack{
//                // Menu Feature to navigate to Home Page
//
//                Button {
//                    menuViewController.showMain()
//                    animateCollapse()
//                } label: {
//                    if menuViewController.menuDisplay == .mainWindow {
//                        HStack{
//                            Image(systemName: "house.fill")
//                            Text("Home")
//                        }
//                        .padding(.all)
//                    } else {
//                        HStack{
//                            Image(systemName: "house")
//                            Text("Home")
//                        }
//                        .padding(.all)
//                    }
//                }
//
//                // Menu Feature to access user's list
//                Button {
//                    menuViewController.showList()
//                    animateCollapse()
//                } label: {
//                    if menuViewController.menuDisplay == .list {
//                        HStack{
//                            Image(systemName: "list.clipboard.fill")
//                            Text("My List")
//                        }
//                        .padding(.all)
//                    } else {
//                        HStack{
//                            Image(systemName: "list.bullet.clipboard")
//                            Text("My List")
//                        }
//                        .padding(.all)
//                    }
//                }
//
//                // Menu Feature to access user's friends
//                Button {
//                    menuViewController.showFriends()
//                    animateCollapse()
//                } label: {
//                    if menuViewController.menuDisplay == .friends {
//                        HStack{
//                            Image(systemName: "person.2.fill")
//                            Text("Friends")
//                        }
//                        .padding(.all)
//                    } else {
//                        HStack{
//                            Image(systemName: "person.2")
//                            Text("Friends")
//                        }
//                        .padding(.all)
//                    }
//                }
//
//                // Menu Feature to access user's groups
//                Button {
//                    menuViewController.showGroups()
//                    animateCollapse()
//                } label: {
//                    if menuViewController.menuDisplay == .groups {
//                        HStack{
//                            Image(systemName: "person.3.sequence.fill")
//                            Text("Groups")
//                        }
//                        .padding(.all)
//                    } else {
//                        HStack{
//                            Image(systemName: "person.3.sequence")
//                            Text("Groups")
//                        }
//                        .padding(.all)
//                    }
//                }
//                Spacer()
//            }
//        }
//    }
//
//    // For animating the dissapearance of menu
//    func animateCollapse() {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//            withAnimation {
//                self.ShowMenu = false
//            }
//        }
//    }
//    // Allows Opacity to be adjusted in this view
//    private func adjustOpacity() {
//        if ShowMenu {
//            opacity = 0.6
//        } else {
//            opacity = 1.0
//        }
//    }
//}



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
