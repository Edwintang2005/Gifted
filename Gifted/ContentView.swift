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
        let drag = DragGesture()
                    .onEnded {
                        if $0.translation.width < -100 {
                            withAnimation {
                                self.ShowMenu = false
                            }
                        }
                    }
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

// Object for the Main view
struct MainView: View{
    
    @EnvironmentObject var sessionManager: SessionManager
    
    @Binding var ShowMenu: Bool
    
    
    var body: some View{
        ScrollView{
            VStack(spacing: 50) {
                HStack {
                    Text("Hello, \(UserDefaults.standard.string(forKey: "Username") ?? "Anonymous User 😊")!")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Spacer()
                    Button("Sign Out", action: sessionManager.signOut)
                }
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                Text("Hello, world!")
            }
            .padding()
        }
        .navigationBarTitle("Home")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear{
            ShowMenu = false
        }
    }
}



// Object for the popup menu view
struct MenuView: View{
    
    @EnvironmentObject var sessionManager: SessionManager
    
    
    var body: some View{
        VStack{
            
            // Menu Feature to access user's list
            NavigationLink(destination: ListView()) {
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
