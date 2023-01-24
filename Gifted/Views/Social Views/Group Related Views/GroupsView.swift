//
//  GroupsView.swift
//  Gifted
//
//  Created by Edwin Tang on 4/12/2022.
//

import SwiftUI

// Page for Groups, not built yet, however physical structures are all already built

struct GroupsView: View {
    
    @ObservedObject var dataStore = DataStore()
    
    let userID = UserDefaults.standard.string(forKey: "UserID") ?? "NullUser"

    
    @State var Groups = [Group]()
    @State var GroupsLength = Int()
    @State var showFloatingMenu1 = false
    @State var showFloatingMenu2 = false
    
    
    
    var body: some View {
        VStack {
            
            if GroupsLength == 0 {
                Spacer()
                Text("It's quite empty in here... \n Add or join your first group!")
                Spacer()
            } else {
                
                ScrollView{
                    ForEach(Groups) {
                        group in NavigationLink(destination: GroupDetailsView(GroupPassed: group)) {
                                                GroupCardView(group: group)
                    }
                        
//                        The code above is supposed to load up the display card for each group but it does not work
                        
              }
                    
                }.frame(width: 369, height: 521)

            }
            
            //The Code Below is for Buttons
            
            HStack {
                
                NavigationLink{
                    CreateNewGroup()
                } label: {
                    Text("Create").createGroupButton()
                        .padding(.all)
                }
              
                NavigationLink{
                    AddToGroups()
                    
                } label: {
                    Text("Join").joinGroupButton()
                        .padding(.all)
                }
                
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear{
            getGroups()
            GroupsLength = Groups.count
            showFloatingMenu1 = false
            showFloatingMenu2 = false
        }
    }
    
    
    //Below this are all the functions Edwin has defined
    
    
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
