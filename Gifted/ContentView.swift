//
//  ContentView.swift
//  Gifted
//
//  Created by Edwin Tang on 3/12/2022.
//

import SwiftUI
import Amplify

struct ContentView: View {
    
    @EnvironmentObject var sessionManager: SessionManager
        
    let user: AuthUser
    
    var body: some View {
        ScrollView{
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                Text("Hello, world!")
                Spacer()
                Button("Sign Out", action: sessionManager.signOut)
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    private struct DummyUser: AuthUser {
        let userId: String = "1"
        let username: String = "dummy"
    }
    
    static var previews: some View {
        ContentView(user: DummyUser())
    }
}
