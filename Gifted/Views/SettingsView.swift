//
//  SettingsView.swift
//  Gifted
//
//  Created by Edwin Tang on 24/1/2023.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var sessionManager: SessionManager
    
    var body: some View {
        VStack(alignment: .leading){
            Text("Settings")
                .colourGradient()
                .font(.largeTitle)
                .padding(.horizontal)
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
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
