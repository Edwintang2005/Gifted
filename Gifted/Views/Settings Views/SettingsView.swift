//
//  SettingsView.swift
//  Gifted
//
//  Created by Edwin Tang on 24/1/2023.
//

import SwiftUI

enum settingsPopup {
    case None
    case Name
    case Password
    case Delete
}

struct SettingsView: View {
    
    @ObservedObject var dataStore = DataStore()
    @EnvironmentObject var sessionManager: SessionManager
    
    @Binding var ImageCache: [String: UIImage]
    let userID = UserDefaults.standard.string(forKey: "UserID") ?? "NullUser"
    let username = UserDefaults.standard.string(forKey: "Username") ?? "NullUser"
    
    @State var user = UserProfile(Username: String(), Name: String())
    @State var popupState = settingsPopup.None
    
    var body: some View {
        
        ZStack {
            VStack(alignment: .center) {
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
                VStack {
                    profilePicture(size: .big)
                        .overlay(alignment: .bottomTrailing) {
                            Image(systemName: "pencil.circle.fill")
                                .imageScale(.large)
                        }
                    Text("@\(username)")
                    Text(user.Name)
                }
                
                Form {
                    Section(header: Text("Profile")) {
                        Button{
                            popupState = .Name
                        } label: {
                            Text("Edit Name")
                        }
                        Button{
                            popupState = .Password
                        } label: {
                            Text("Change Password")
                        }
                    }
                    
                    Section {
                        Button("Sign Out", action: sessionManager.signOut)
                        Button{
                            popupState = .Delete
                        } label: {
                            Text("Delete Account")
                        }
                    }
                }
            }
            .disabled(popupState != .None)
            .opacity(popupState == .None ? 1: 0.5)
            .padding(.horizontal)
            .onAppear{
                fetchUser()
            }
            
            if popupState == .Name {
                ChangeNameView(displayPopup: $popupState)
            } else if popupState == .Password {
                ChangePasswordView(displayPopup: $popupState)
            } else if popupState == .Delete {
                DeleteProfileView(displayPopup: $popupState)
            }
        }
    }
    
    func fetchUser() {
        user = dataStore.fetchUser(userID: userID)
    }
}

//struct SettingsView_Previews: PreviewProvider {
//    @State var testCache = [String: UIImage]()
//    static var previews: some View {
//        SettingsView(ImageCache: $testCache)
//    }
//}
