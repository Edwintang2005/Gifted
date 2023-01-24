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
    
    @EnvironmentObject var menuViewController: MenuViewController
    @EnvironmentObject var sessionManager: SessionManager

    let userID = UserDefaults.standard.string(forKey: "UserID") ?? "NullUser"
    let user: AuthUser
    
    var body: some View {
        TabView {
            MainView()
                .tabItem{
                    Label("Home", systemImage: "house")
                }
            ListView(QueryID: userID)
                .tabItem{
                    Label("Wishlist", systemImage: "list.bullet.clipboard")
                }
            SocialView()
                .tabItem{
                    Label("Socials", systemImage: "person.3.sequence")
                }
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
