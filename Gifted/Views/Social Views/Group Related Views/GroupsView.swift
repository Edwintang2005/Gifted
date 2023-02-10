//
//  GroupsView.swift
//  Gifted
//
//  Created by Edwin Tang on 4/12/2022.
//

import Amplify
import SwiftUI

// Page for Groups, not built yet, however physical structures are all already built
struct GroupsView: View {
    
    @ObservedObject var dataStore = DataStore()
    @EnvironmentObject var sessionManager: SessionManager
    
    @Binding var ImageCache: [String: UIImage]
    @Binding var displayPopup: popupState
    
    let userID = UserDefaults.standard.string(forKey: "UserID") ?? "NullUser"
    
    @State var Groups = [Group]()
    @State var GroupsLength = Int()
    @State var showCreateGroup = false
    
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("GROUPS").boldText()
                        .padding(.horizontal)
                    Spacer()
                    Menu {
                        Button {
                            displayPopup = .joinGroup
                        } label: {
                            Text("Join a Group")
                        }
                        Button {
                            displayPopup = .createGroup
                        } label: {
                            Text("Make a Group")
                        }
                    } label: {
                        Image(systemName: "person.3")
                            .imageScale(.large)
                            .overlay(alignment:.bottomLeading){
                                Image(systemName: "plus.circle.fill")
                                    .imageScale(.small)
                                    .offset(
                                        x: CGFloat(-6),
                                        y: CGFloat(5)
                                    )
                            }
                    }
                }
                .padding(.all)
                
                if GroupsLength == 0 {
                    Spacer()
                    Text("It's quite empty in here... \n Add or join your first group!")
                    Spacer()
                } else {
                    ScrollView {
                        ForEach(Groups) {
                            Group in NavigationLink{
                                GroupDetailsView(GroupPassed: Group)
                            } label: {
                                GroupDisplayCards(group: Group, ImageCache: $ImageCache)
                            }
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear{
            getGroups()
            GroupsLength = Groups.count
        }
        .onChange(of: displayPopup) { _ in
            getGroups()
            GroupsLength = Groups.count
        }
    }
    
    func getGroups() {
        Groups = dataStore.fetchGroups(userID: userID)
    }
    
    func deleteGroup(indexSet: IndexSet) {
        print("Deleted group at \(indexSet)")
        
        var updatedList = Groups
        updatedList.remove(atOffsets: indexSet)
        
        guard let item =
                Set(updatedList)
            .symmetricDifference(Groups).first else
        {return}
        
        dataStore.changeGroups(action: .removeFrom, userID: userID, change: item)
        
        getGroups()
    }
}

//struct GroupsView_Previews: PreviewProvider {
//    static var previews: some View {
//        GroupsView()
//    }
//}
