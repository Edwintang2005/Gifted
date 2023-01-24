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
    
    @AppStorage("NameOfUser") var NameOfUser: String = "Michelle"
    //Make sure to change back "Michelle" to nothing
    
    
    // Variable for storing the User's username for use throughout the app
    @AppStorage("Username") var Username: String = ""
    @AppStorage("UserID") var UserID: String = ""
    
    private let adaptiveColumns = [
        GridItem(.adaptive(minimum: 170))
    ]
    
    
    var body: some View{
        NavigationView {
            VStack(alignment: .leading) {
                HStack {
                    // Text that displays the User's name
                    Text("Welcome back, \n\(NameOfUser)!").colourGradient()
                        .padding([.all])
                        .font(.system(size: 36, weight: .bold, design: .default))
                    Spacer()
                }
                
                Text("Your Wishlist")
                    .subtitle()
                    .padding([.leading, .trailing])
                
                
                ScrollView(showsIndicators: true) {
                    LazyVGrid(columns: adaptiveColumns, spacing: 20) {
                        
                        ForEach(listitems) {
                            item in DisplayCards(listItem: item)
                            
                            
                            
                        }
                    }
                }
                //                            ScrollView(.horizontal, showsIndicators: false){
                //                                HStack{
                //                                    ForEach(listitems) { item in
                //                                        DisplayCards(listItem: item).padding(6)
                
                .padding(.leading)
                Spacer()
            }
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
        listitems = dataStore.fetchListItems(listid: "arbitrary string")
    }
}




//struct MainView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainView()
//    }
//}


//code that roger deleted which might be important
//.padding(.vertical)
//    .navigationBarTitle("Home")
//    .navigationBarTitleDisplayMode(.inline)
//    .navigationBarItems(trailing: (
//        Button{print("Sign out clicked")} label: {
//            Text("Sign Out")
//        }
//    ))

//                            ForEach(1..<4) {
//Text("\($0) Gift")
//    .font(.system(size: 15, weight: .medium, design: .default))
//    .foregroundColor(Color(.sRGB, red: 36/255, green: 74/255, blue: 71/255))
//    .frame(width: 182, height: 230)
//    .background(Color(red: 0.92, green: 0.94, blue: 0.945))
//
//}
