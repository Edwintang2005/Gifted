//
//  AddToGroups.swift
//  Gifted
//
//  Created by Edwin Tang on 5/1/2023.
//

import Amplify
import SwiftUI

//Page trigged by add button in Groups
struct AddToGroups: View{
    
    @ObservedObject var dataStore = DataStore()
    @Binding var displayPopup: popupState
    
    let userID = UserDefaults.standard.string(forKey: "UserID") ?? "NullUser"
    
    let cardWidth = UIScreen.main.bounds.size.width * 9/10
    let cardHeight = UIScreen.main.bounds.size.height * 3/8
    let cornerRadius = 10.0
    
    @State var groupID = String()
    @State var groupName = String()
    @State var validGroup = true
    
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
                Text("Join group")
                    .boldText()
                TextField("Group Name", text: $groupName)
                    .pretty()
                TextField("Group ID", text: $groupID)
                    .pretty()
                Text("That Group Name and ID doesn't exist")
                    .foregroundColor(validGroup ? .clear: .red)
                Button{
                    saveFriend()
                } label: {
                    Text("Join")
                }.pretty()
            }
            .padding(.bottom)
        }
        .background(Color(.sRGB, red: 237/255, green: 240/255, blue: 241/255))
        .padding(.all)
        .frame(width: cardWidth, height: cardHeight)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    }
        
    
    func saveFriend() {
        let NameandShortID = groupName + groupID
        print(NameandShortID)
        // Fetching ID of Friend and adding to friend list
        let group = dataStore.fetchGroup(NameAndShortID: NameandShortID)
        if group.Name != "" {
            dataStore.changeGroups(action: .addTo, userID: userID, change: group)
            displayPopup = .None
        } else {
            validGroup = false
        }
    }
}

//struct AddToGroups_Previews: PreviewProvider {
//    static var previews: some View {
//        AddToGroups()
//    }
//}
