//
//  CreateNewGroup.swift
//  Gifted
//
//  Created by Edwin Tang on 5/1/2023.
//

import SwiftUI
import Amplify


struct CreateNewGroup: View{
    
    @ObservedObject var dataStore = DataStore()
    @Environment(\.presentationMode) var presentationMode
    
    let userID = UserDefaults.standard.string(forKey: "UserID") ?? "NullUser"
    
    @State var Name = String()
    
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
        let createdGroup = dataStore.createGroup(Groupname: Name, userID: userID)
        addGrouptoUser(GroupObj: createdGroup)
    }
    
    func addGrouptoUser(GroupObj: Group) {
        print(GroupObj.ShortID)
        // Replace with code to append group to user file
        
        Amplify.DataStore.query(UserProfile.self, byId: userID) { result in
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


struct CreateNewGroup_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewGroup()
    }
}
