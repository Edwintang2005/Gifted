//
//  ChangeNameView.swift
//  Gifted
//
//  Created by Edwin Tang on 30/1/2023.
//

import SwiftUI


struct ChangeNameView: View {
    
    @ObservedObject var dataStore = DataStore()
    @EnvironmentObject var sessionManager: SessionManager
    
    @Binding var displayPopup: settingsPopup
    
    let userID = UserDefaults.standard.string(forKey: "UserID") ?? "NullUser"
    
    let cardWidth = UIScreen.main.bounds.size.width * 9/10
    let cardHeight = UIScreen.main.bounds.size.height * 1/4
    let cornerRadius = 10.0
    
    @State var name = String()
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    displayPopup = .None
                } label: {
                    Image(systemName: "x.circle")
                        .imageScale(.large)
                }
            }
            .padding(.top)
            VStack {
                Text("Set a new name")
                    .boldText()
                TextField("New Name", text: $name)
                    .pretty()
                Button{
                    saveName()
                    displayPopup = .None
                } label: {
                    Text("Save")
                }.pretty()
            }
            .padding(.bottom)
        }
        .background(Color(.sRGB, red: 237/255, green: 240/255, blue: 241/255))
        .padding(.all)
        .frame(width: cardWidth, height: cardHeight)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    }
    
    
    func saveName() {
        dataStore.changeName(userID: userID, newName: name)
        sessionManager.changeName(newName: name)
    }
}

//struct ChangeNameView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChangeNameView()
//    }
//}
