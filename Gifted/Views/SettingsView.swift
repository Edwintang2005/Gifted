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
    
    var body: some View {
        VStack(alignment: .leading){
            Text("Settings")
                .colourGradient()
                .padding(.bottom)
            List{
                Text("Edit Name")
                Text("Change Image")
                Text("Change Password")
                Text("Delete Account")
            }
            Spacer()
            HStack{
                Spacer()
                Button("Sign Out", action: sessionManager.signOut)
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
