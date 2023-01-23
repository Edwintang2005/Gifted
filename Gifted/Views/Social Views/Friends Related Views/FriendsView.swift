//
//  FriendsView.swift
//  Gifted
//
//  Created by Edwin Tang on 3/12/2022.
//


import Combine
import SwiftUI

// Page for friends lists, not yet built although buttons and structures are all done, just need backend functionality
struct FriendsView: View {
    
    @ObservedObject var dataStore = DataStore()
    
    
    let username = UserDefaults.standard.string(forKey: "Username") ?? "NullUser"
    let userID = UserDefaults.standard.string(forKey: "UserID") ?? "NullUser"
    
    @State var Friends = [UserProfile]()
    @State var FriendsLength = Int()
    
    
    var body: some View {
        
        VStack {
            HStack {
                Text("CONTACTS").boldText()
                    .padding([.top, .leading, .trailing])
                Spacer()
                NavigationLink{
                    AddToFriends()
                } label: {
                    Image("􀜕")
                }.padding([.top, .leading, .trailing])
            }
     
            if FriendsLength == 0 {
                Spacer()
                Text("Hopefully it's not normally like this... \nAdd some friends!")
                    .multilineTextAlignment(.center)
                Spacer()
                
            } else {
                
                ScrollView {
                    
                    //Code here Displays all friends
                    //ForEach()
                
                    
                }.frame(width: 369, height: 500)
                
                
            }
            

            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear{
            getFriends()
            FriendsLength = Friends.count
        }
    }

    
    func getFriends() {
        Friends = dataStore.fetchFriends(userID: userID)
    }
    
    func deleteFriend(indexSet: IndexSet) {
        print("Deleted friend at \(indexSet)")
        
        var updatedList = Friends
        updatedList.remove(atOffsets: indexSet)

        guard let item =
                Set(updatedList)
            .symmetricDifference(Friends).first else
        {return}
        
        // Function to remove friend from list
        dataStore.changeFriends(action: .removeFrom, userID: userID, change: item)
        getFriends()
    }
}






//struct FriendsView_Previews: PreviewProvider {
//    static var previews: some View {
//        FriendsView()
//    }
//}
