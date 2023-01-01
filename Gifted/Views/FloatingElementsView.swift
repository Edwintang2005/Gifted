//
//  FloatingElementsView.swift
//  Gifted
//
//  Created by Edwin Tang on 4/12/2022.
//

import SwiftUI
import Amplify



//Page view used in lists to allow users to add to their list
struct AddToList: View{

    @ObservedObject var dataStore = DataStore()
    @Environment(\.presentationMode) var presentationMode
    
    // Variables required for functions
    @Binding var lists: [UserList]
    @Binding var listNumber: Int
    
    //Variables for the form
    @State var name = String()
    @State var link = String()
    @State var price = String()
    @State var description = String()
    
    
    //Variables for getting image input
    @State var showingImagePicker = false
    @State var inputImage: UIImage?
    @State var image: Image?
    
    var body: some View{
        
        VStack(alignment: .leading) {
            Spacer()
            TextField("Name", text: $name).pretty()
            TextField("Link", text: $link).pretty()
                .keyboardType(.URL)
            TextField("Price", text: $price).pretty()
                .keyboardType(.decimalPad) // enforces number input for prices
            TextField("Short Description", text: $description).pretty()
            Text("Select an image for this Item:").small()
            ZStack(alignment: .center){
                if (image == nil) {
                    Rectangle()
                        .fill(.secondary)
                    Text("Tap to Select an image").listtext()
                } else {
                    image?
                        .resizable()
                        .scaledToFit()
                }
            }
            .onTapGesture{
                showingImagePicker = true
            }
            Button{
                StoreImage(inputImage)
                saveListItem()
                UserDefaults.standard.set(nil, forKey: "ImageKey")
            } label: {
                    Text("Save")
                }.pretty()
            Spacer()
        }
        .padding(.horizontal)
        .navigationTitle("Create a New Item")
        .onChange(of: inputImage) { _ in loadImage() }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $inputImage)
        }
    }
    
    
    // Function that updates list items to the cloud
    func saveListItem() {
        
        print(name)
        let item = ListItem(id: UUID().uuidString,
                            Name: name,
                            Price: price,
                            ShortDescription: description,
                            ImageKey: UserDefaults.standard.string(forKey: "ImageKey"),
                            Link: link)
        Amplify.DataStore.save(item) { result in
            switch result {
            case .success:
                print("Saved Item")
                // Adding Item to User's list
                dataStore.changeLists(action: .addTo, list: lists[listNumber], change: item)
                presentationMode.wrappedValue.dismiss()
            case .failure(let error):
                print("Could not create Item - \(error)")
            }
        }
    }
    
    // Function that saves image input if exists in the database Storage
    func StoreImage(_ image: UIImage?) {
        guard let ImageData = image?.jpegData(compressionQuality:0.5) else {return}
        let key = UUID().uuidString + ".jpg"
        print(key)
        @AppStorage("ImageKey") var ImageKey: String = ""
        ImageKey = key
        _ = Amplify.Storage.uploadData(key: key, data: ImageData) { result in
            switch result {
            case .success:
                print("Uploaded to DB!")
            case .failure(let error):
                print("Could not Upload - \(error)")
            }
        }
    }
    
    
    // Function that displays the image that user has picked
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }
}


//Page trigged by add button in Friends
struct AddToFriends: View{
    
    @Environment(\.presentationMode) var presentationMode
    
    let selfUsername = UserDefaults.standard.string(forKey: "Username") ?? "NullUser"
    
    @State var username = String()
    
    
    var body: some View{
        VStack {
            Spacer()
            TextField("Friend's Username", text: $username).pretty()
            Spacer()
            Button{
                saveFriend()
            } label: {
                Text("Save")
            }.pretty()
            Spacer()
        }
        .navigationTitle("Add a Friend!")
        .padding(.horizontal)
    }
        
    
    func saveFriend() {
        
        let UserObj = User.keys
        print(username)
        
        
        
        // Fetching ID of Friend and adding to friend list
        Amplify.DataStore.query(User.self, where: UserObj.Username == username) { result in
            switch result {
            case.success(let Friends):
                if let Friend = Friends.first {
                    // Fetching own User Item
                    Amplify.DataStore.query(User.self, where: UserObj.Username == selfUsername) { result in
                        switch result {
                        case .success( let user):
                            if var userSelf = user.first {
                                var friends = userSelf.Friends
                                friends.append(Friend.id)
                                userSelf.Friends = friends
                                Amplify.DataStore.save(userSelf) {result in
                                    switch result {
                                    case .success:
                                        print("Successfully added Friend")
                                        presentationMode.wrappedValue.dismiss()
                                    case .failure(let error):
                                        print("Could not add Friend - \(error)")
                                    }
                                }
                            }
                        case .failure(let error):
                            print("Could not fetch Self - \(error)")
                        }
                    }
                }
            case.failure(let error):
                print("Could not fetch Friend - \(error)")
            }
        }
    }
}


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
        Amplify.DataStore.query(Group.self) {result in
            switch result {
            case .success(let Group):
                self.GroupList = Group
            case .failure(let error):
                print(error)
            }
        }
    }
}

struct CreateNewGroup: View{
    
    @Environment(\.presentationMode) var presentationMode
    @State var ShortID = String()
    @State var Name = String()
    @State var Members = [String]()
    
    @State var showingImagePicker = false
    @State var inputImage: UIImage?
    @State var image: Image?
    
    var body: some View{
        VStack {
            Spacer()
            Text("Please Enter a Name for this group. \n To invite your friends, just give them the Name and ID of the group!").pretty()
            Spacer()
            TextField("Group Name", text: $Name).pretty()
            Spacer()
            Text("Select an image for this Item:").small()
            ZStack(alignment: .center){
                if (image == nil) {
                    Rectangle()
                        .fill(.secondary)
                    Text("Tap to Select an image").listtext()
                } else {
                    image?
                        .resizable()
                        .scaledToFit()
                }
            }
            .onTapGesture{
                showingImagePicker = true
            }
            Button{
                StoreImage(inputImage)
                saveGroup()
                UserDefaults.standard.set(nil, forKey: "ImageKey")
            } label: {
                Text("Create")
            }.pretty()
        }
        .navigationTitle("Create a Group!")
        .padding(.horizontal)
        .onChange(of: inputImage) { _ in loadImage() }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $inputImage)
        }
    }
    
    func saveGroup() {
        print(Name)
        let userID = UserDefaults.standard.string(forKey: "UserID") ?? "NullUser"
        
        ShortID = UUID().uuidString
        let small = ShortID.prefix(8)
        ShortID = String(small)
        let GroupNameandID = Name + ShortID
        Members = [userID]
        let Group = Group(id: UUID().uuidString,
                          Name: Name,
                          ShortID: ShortID,
                          NameAndShortID: GroupNameandID,
                          Members: Members,
                          ImageKey: UserDefaults.standard.string(forKey: "ImageKey"))
        Amplify.DataStore.save(Group) {result in
            switch result {
            case .success:
                print("Saved Group!")
                addGrouptoUser(GroupObj: Group)
                presentationMode.wrappedValue.dismiss()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func addGrouptoUser(GroupObj: Group) {
        let userID = UserDefaults.standard.string(forKey: "UserID") ?? "NullUser"
        
        print(GroupObj.ShortID)
        // Replace with code to append group to user file
        
        Amplify.DataStore.query(User.self, byId: userID) { result in
            switch result {
            case .success(let user):
                if var returnedUser = user {
                    var userGroups = returnedUser.Groups
                    userGroups.append(GroupObj.id)
                    returnedUser.Groups = userGroups
                    Amplify.DataStore.save(returnedUser) { result in
                        switch result {
                        case .success:
                            print("Added Group to User")
                        case .failure(let error):
                            print("Could not add Group to User - \(error)")
                        }
                    }
                }
            case .failure(let error):
                print("Could not get User - \(error)")
            }
        }
        
    }
    
    func StoreImage(_ image: UIImage?) {
        guard let ImageData = image?.jpegData(compressionQuality:0.5) else {return}
        let key = UUID().uuidString + ".jpg"
        print(key)
        @AppStorage("ImageKey") var ImageKey: String = ""
        ImageKey = key
        _ = Amplify.Storage.uploadData(key: key, data: ImageData) { result in
            switch result {
            case .success:
                print("Uploaded to DB!")
            case .failure(let error):
                print("Could not Upload - \(error)")
            }
        }
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }
}
