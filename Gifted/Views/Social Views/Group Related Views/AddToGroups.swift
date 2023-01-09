//
//  AddToGroups.swift
//  Gifted
//
//  Created by Edwin Tang on 5/1/2023.
//


import SwiftUI

//Page trigged by add button in Groups
struct AddToGroups: View{

    @Environment(\.presentationMode) var presentationMode
    
    @State var groupID = String()
    @State var groupName = String()
    @State var GroupList = [Group]()
    
    @State private var searchedText = ""
    
    var groupListFiltered: [Group] {
        if searchedText.isEmpty {
            return GroupList
        } else {
            return GroupList.filter { $0.Name.contains(searchedText)}
        }
    }
    
    var body: some View{
        VStack {
            List {
                ForEach(groupListFiltered) {
                    group in NavigationLink{
                        GroupDetailsView(GroupPassed: group)
                    } label: {
                        Text("\(group.Name) # \(group.ShortID)")
                    }
                }
            }
        }
        .onAppear{
            getGroups()
        }
        .searchable(text: $searchedText)
        .navigationTitle("Find a Group")
    }
    
    func getGroups() {
    }
}

struct AddToGroups_Previews: PreviewProvider {
    static var previews: some View {
        AddToGroups()
    }
}
