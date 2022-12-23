//
//  FriendsView.swift
//  Gifted
//
//  Created by Edwin Tang on 3/12/2022.
//


import Amplify
import Combine
import SwiftUI

// Page for friends lists, not yet built although buttons and structures are all done, just need backend functionality
struct FriendsView: View {
    
    @EnvironmentObject var sessionManager: SessionManager
    
    @State var showAddToFriends = false
    @State var Friends = [String]()
    @State var FriendsLength = Int()
    
    
    var body: some View {
        ZStack {
            VStack {
                if FriendsLength == 0 {
                    Spacer()
                    Text("You have No Friends yet! 😢").large()
                    Spacer()
                    Text("Why don't we start by adding an item using the + button!").large()
                    Spacer()
                } else {
                    List {
                        ForEach(Friends, id: \.self) {
                            Friend in NavigationLink{
                                ListView(QueryUsername: Friend)
                            } label: {
                                Text(Friend)
                            }
                        }
                        .onDelete(perform: deleteFriend)
                    }
                    
                }
            }
            VStack{
                Spacer()
                HStack{
                    Spacer()
                    NavigationLink{
                        AddToFriends()
                    } label: {
                        Image(systemName: "plus.circle.fill").floaty()
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear{
            getFriends()
            FriendsLength = Friends.count
        }
        .navigationBarTitle("Friends")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: (
            Button(action: {
                getFriends()
                FriendsLength = Friends.count
            }) {
                Image(systemName: "arrow.clockwise")
                    .imageScale(.large)
            }
        ))
    }
    
    func getFriends() {
        let username = UserDefaults.standard.string(forKey: "Username") ?? "NullUser"
        let UserObj = User.keys
        Amplify.DataStore.query(User.self, where: UserObj.Username == username) {result in
            switch result {
            case .success(let user):
                if let singleUser = user.first {
                    print(singleUser.Friends)
                    self.Friends = singleUser.Friends
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func deleteFriend(indexSet: IndexSet) {
        print("Deleted friend at \(indexSet)")
        
        var updatedList = Friends
        updatedList.remove(atOffsets: indexSet)
        
        guard let item =
                Set(updatedList)
            .symmetricDifference(Friends).first else
        {return}
        
        // Function to remove friend from list required
        
        //        Amplify.DataStore.delete(item) { result in
        //            switch result {
        //            case .success:
        //                print("Deleted Friend")
        //            case .failure(let error):
        //                print("Could not delete Friend - \(error)")
        //            }
        //
        //        }
        getFriends()
    }
}






//struct FriendsView_Previews: PreviewProvider {
//    static var previews: some View {
//        FriendsView()
//    }
//}
