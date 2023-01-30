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
    
    let userID = UserDefaults.standard.string(forKey: "UserID") ?? "NullUser"
    
    @Binding var displayPopup: popupState
    
    @State var Name = String()
    
    @State var showingImagePicker = false
    @State var inputImage: UIImage?
    @State var image: Image?
    
    var body: some View{
        VStack {
            HStack {
                Spacer()
                Button {
                    displayPopup = .None
                } label: {
                    Image(systemName: "x.circle")
                        .imageScale(.large)
                }
            }
            .padding(.top)
            Text("Create a Group!").title()
            Spacer()
            TextField("Group Name", text: $Name).pretty()
            Spacer()
            Text("Select an image for this Item:")
            ZStack(alignment: .center){
                if (image == nil) {
                    RoundedRectangle(cornerRadius: 7, style: .continuous)
                        .fill(.white)
                        .border(Color(.sRGB, red: 217/255, green: 217/255, blue: 217/255), width: 1)
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
        .padding(.horizontal)
        .background(Color(.sRGB, red: 237/255, green: 240/255, blue: 241/255))
        .onChange(of: inputImage) { _ in loadImage() }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $inputImage)
        }
    }
    
    func saveGroup() {
        print(Name)
        
        var ShortID = UUID().uuidString
        let small = ShortID.prefix(8)
        ShortID = String(small)
        let Members = [String]()
        let groupObj = Group(id: UUID().uuidString,
                             Name: Name,
                             ShortID: ShortID,
                             NameAndShortID: Name+ShortID,
                             Members: Members,
                             ImageKey: UserDefaults.standard.string(forKey: "ImageKey"))
        
        let createdGroup = dataStore.createGroup(GroupObj: groupObj, userID: userID)
        dataStore.changeGroups(action: .addTo, userID: userID, change: createdGroup)
        displayPopup = .None
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


//struct CreateNewGroup_Previews: PreviewProvider {
//    static var previews: some View {
//        CreateNewGroup()
//    }
//}
