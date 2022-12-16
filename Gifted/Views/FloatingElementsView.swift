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

    @Environment(\.presentationMode) var presentationMode
        
    
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
            TextField("Link?", text: $link).pretty()
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
        .navigationTitle("Create a New Item!")
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
                            Link: link,
                            Reservation: [],
                            userID: UserDefaults.standard.string(forKey: "Username") ?? "NullUser")
        Amplify.DataStore.save(item) { result in
            switch result {
            case .success:
                print("Saved Item")
                presentationMode.wrappedValue.dismiss()
            case .failure(let error):
                print(error)
                
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
        print(username)
        let Friend = Friend(id: UUID().uuidString,
                            Username: username,
                            OwnerUser: UserDefaults.standard.string(forKey: "Username") ?? "NullUser")
        Amplify.DataStore.save(Friend) { result in
            switch result {
            case .success:
                print("Saved Friend!")
                presentationMode.wrappedValue.dismiss()
            case .failure(let error):
                print(error)
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
    
    
    var body: some View{
        VStack {
            Spacer()
            Text("Please Enter the Group Name and ID as presented to group creator!")
            HStack{
                TextField("Group Name", text: $groupName).pretty()
                Text(" # ")
                TextField("Group ID", text: $groupID).pretty()
            }
            Spacer()
            Button{
                saveGroupLink()
            } label: {
            Text("Save")
            }.pretty()
        }
        .navigationTitle("Join a Group!")
        .padding(.horizontal)
    }
    
    func saveGroupLink() {
        print(groupID)
        // Creating Link record between user and group
        let GroupLink = GroupLink(id: UUID().uuidString,
                                  GroupID: groupID,
                                  GroupName: groupName,
                                  OwnerUser: UserDefaults.standard.string(forKey: "Username") ?? "NullUser")
        Amplify.DataStore.save(GroupLink) { result in
            switch result {
            case .success:
                print("Saved Group Link!")
                presentationMode.wrappedValue.dismiss()
            case .failure(let error):
                print(error)
            }
        }
        
        // Appending user name to group
        getGroup()
        if GroupList.count == 1 {
            var tempList = GroupList[0]
            var MemberList = tempList.Members
            MemberList.append( UserDefaults.standard.string(forKey: "Username") ?? "NullUser")
            tempList.Members = MemberList
            Amplify.DataStore.save(tempList) {result in
                switch result {
                case .success:
                    print("Added Member to group.")
                case .failure(let error):
                    print(error)
                }
            }
        } else {
            print("Non-unique GroupName and ID")
        }
    }
    
    func getGroup() {
        let GroupObj = Group.keys
        Amplify.DataStore.query(Group.self, where: GroupObj.ShortID == groupID && GroupObj.Name == groupName) {result in
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
    
    var body: some View{
        VStack {
            Spacer()
            Text("Please Enter a Name for this group. \n To invite your friends, just give them the Name and ID of the group!").pretty()
            Spacer()
            TextField("Group Name", text: $Name).pretty()
            Spacer()
            Button{
                saveGroup()
            } label: {
                Text("Create")
            }.pretty()
        }
        .navigationTitle("Create a Group!")
        .padding(.horizontal)
    }
    
    func saveGroup() {
        print(Name)
        let Username = UserDefaults.standard.string(forKey: "Username") ?? "NullUser"
        ShortID = UUID().uuidString
        let small = ShortID.prefix(8)
        ShortID = String(small)
        let GroupNameandID = Name + ShortID
        Members = [Username]
        let Group = Group(id: UUID().uuidString,
                          ShortID: ShortID,
                          Name: Name,
                          NameAndShortID: GroupNameandID,
                          Members: Members)
        Amplify.DataStore.save(Group) {result in
            switch result {
            case .success:
                print("Saved Group!")
                createGroupLink()
                presentationMode.wrappedValue.dismiss()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func createGroupLink() {
        print(ShortID)
        // Creating Link record between user and group
        let GroupLink = GroupLink(id: UUID().uuidString,
                                  GroupID: ShortID,
                                  GroupName: Name,
                                  OwnerUser: UserDefaults.standard.string(forKey: "Username") ?? "NullUser")
        Amplify.DataStore.save(GroupLink) { result in
            switch result {
            case .success:
                print("Saved Group Link!")
                presentationMode.wrappedValue.dismiss()
            case .failure(let error):
                print(error)
            }
        }
    }
}
