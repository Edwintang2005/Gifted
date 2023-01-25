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
    
    let userID = UserDefaults.standard.string(forKey: "UserID") ?? "NullUser"
    
    @State var Groups = [Group]()
    @State var GroupsLength = Int()
    @State var showFloatingMenu1 = false
    @State var showFloatingMenu2 = false
    
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("GROUPS").boldText()
                        .padding(.horizontal)
                    Spacer()
                    NavigationLink {
                        AddToGroups()
                    } label: {
                        Image(systemName:"plus.rectangle")
                            .scaledToFit()
                            .foregroundColor(Color(.sRGB, red: 36/255, green: 74/255, blue: 71/255))
                    }
                }
                .padding(.all)
                
                if GroupsLength == 0 {
                    Spacer()
                    Text("It's quite empty in here... \n Add or join your first group!")
                    Spacer()
                } else {
                    List {
                        ForEach(Groups) {
                            Group in NavigationLink{
                                GroupDetailsView(GroupPassed: Group)
                            } label: {
                                Text(Group.Name)
                            }
                        }
                        .onDelete(perform: deleteGroup)
                    }
                }
            }
            VStack{
                Spacer()
                if showFloatingMenu2 == false {
                    
                } else {
                    VStack(alignment: .trailing) {
                        NavigationLink{
                            AddToGroups()
                        } label: {
                            
                            HStack{
                                Spacer()
                                Text("Join a Group")
                                    .padding(.all)
                            }
                        }
                    }
                }
                if showFloatingMenu1 == false {
                    
                } else {
                    VStack(alignment: .trailing) {
                        NavigationLink{
                            CreateNewGroup()
                        } label: {
                            HStack{
                                Spacer()
                                Text("Create a Group")
                                    .padding(.all)
                            }
                        }
                    }
                }
                HStack{
                    Spacer()
                    Button{
                        showFloatingMenu1.toggle()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                            self.showFloatingMenu2.toggle()
                        })
                    } label: {
                        Image(systemName: "plus.circle.fill").floaty()
                    }
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
