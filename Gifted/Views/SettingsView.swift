//
//  SettingsView.swift
//  Gifted
//
//  Created by Edwin Tang on 24/1/2023.
//

import SwiftUI

struct SettingsView: View {
    
    @ObservedObject var dataStore = DataStore()
    @EnvironmentObject var sessionManager: SessionManager
    
    @Binding var ImageCache: [String: UIImage]
    let userID = UserDefaults.standard.string(forKey: "UserID") ?? "NullUser"
    
    
    var body: some View {
        VStack(alignment: .leading){
            HStack {
                Text("Settings")
                    .colourGradient()
                    .padding(.bottom)
                Spacer()
                Button{
                    dataStore.refreshDataStore()
                } label: {
                    Image(systemName: "arrow.clockwise")
                        .imageScale(.large)
                }
            }
            List{
                Text("Edit Name")
                Text("Change Image")
                Text("Change Password")
                Button{
                    dataStore.deleteUser(userID: userID)
                    sessionManager.deleteUser()
                } label: {
                    Text("Delete Account")
                }
            }
            Spacer()
            HStack{
                Spacer()
                Button("Sign Out", action: sessionManager.signOut)
                    .pretty()
                Spacer()
            }
            .padding(.vertical)
        }
        .padding(.horizontal)
    }
}

//struct SettingsView_Previews: PreviewProvider {
//    @State var testCache = [String: UIImage]()
//    static var previews: some View {
//        SettingsView(ImageCache: $testCache)
//    }
//}
