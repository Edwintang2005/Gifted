//
//  GroupDetailsView.swift
//  Gifted
//
//  Created by Edwin Tang on 11/12/2022.
//

import Amplify
import SwiftUI


struct GroupDetailsView: View {
    
    @State var GroupName: String
    @State var Title = String()
    @State var InputLength = Int()
    
    let Groups : [Group]
    
    
    
    var body: some View {
        let Group = Groups.first
        VStack{
            Spacer()
            if let Group = Group {
                if InputLength == 0 {
                    Text("Error, Group has no members, are you sure this group exists?").medium()
                } else if InputLength >= 2 {
                    Text("There appears to be more than one group with that name and ID. \n Contact the group owner to delete your group and make a new one!").medium()
                } else {
                    List{
                        Section{
                            ForEach(Group.Members, id: \.self) {
                                Member in NavigationLink{
                                    ListView(QueryUsername: Member)
                                } label: {
                                    Text(Member).listtext()
                                }
                            }
                        } header: {
                            Text("Members of this group (Including yourself):")
                        }
                    }
                }
            }
        }
        .onAppear{
            GetTitle()
            print(Groups)
        }
        .navigationTitle(Title)
    }
    
    func GetTitle() {
        let GroupObject = Groups.first
        Title = (GroupObject?.Name ?? " ") + " # " + (GroupObject?.ShortID ?? " ")
        InputLength = Groups.count
    }
}



// Preview Simulator code, disregard

//struct GroupDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        GroupDetailsView()
//    }
//}
