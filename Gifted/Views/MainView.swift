//
//  MainView.swift
//  Gifted
//
//  Created by Edwin Tang on 31/12/2022.
//

import SwiftUI

// Object for the Main view or what is essentially our home screen
struct MainView: View {
    
    @ObservedObject var dataStore = DataStore()
    
    @State private var userProfile = UserProfile(Username: "NULL", Name: String())
    
    @State var listitems = [ListItem]()
    var listitemsLength = Int()
    @State var ImageCache = [String: UIImage]()
    
    @AppStorage("NameOfUser") var NameOfUser: String = ""
    
    // Variable for storing the User's username for use throughout the app
    @AppStorage("Username") var Username: String = ""
    @AppStorage("UserID") var UserID: String = ""
    
    var body: some View{
        NavigationView {
                VStack(alignment: .leading) {
                    HStack {
                        // Text that displays the User's name
                        Text("Hello, \(NameOfUser)!").homepagename()
                            .padding(.horizontal)
                        Spacer()
                    }
                    // replace below with Roger's design of Homescreen
                    Text("Top Items:")
                        .font(.title2)
                        .padding([.top, .leading, .trailing])
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack{
                            ForEach(listitems) { item in
                                DisplayCards(listItem: item).padding(6)
                            }
                        }
                    }
                    .padding(.leading)
                    Spacer()
                }
                .padding(.vertical)
                .navigationBarTitle("Home")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(trailing: (
                    Button("Sign Out", action: print("Sign out clicked"))
                ))
                .onAppear{
                    fetchUserInfo()
                    getListItem()
                }
        }
    }
    
    func getImage(Imagekey: String?) {
        guard let Key = Imagekey else {return}
    }
    
    
    func fetchUserInfo() {
        //Get Username and create/check for user object - need to resolve occassional query return empty issue
    }
    
    func getListItem() {
        listitems = dataStore.allItemsQuery()
    }
}




//struct MainView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainView()
//    }
//}
