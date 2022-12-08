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
    
    //Variable for displaying alert
    @State var errors = String()
    
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
                            userID: UserDefaults.standard.string(forKey: "Username") ?? "nullUser")
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
    
    var body: some View{
        Spacer()
        Text("Aww Shucks, this page hasn't been developed yet! \n \n Maybe if we had more funding ;(")
            .pretty()
        Spacer()
        Button{
            presentationMode.wrappedValue.dismiss()
        } label: {
            Text("CLOSE")
        }.pretty()
    }
}


//Page trigged by add button in Groups
struct AddToGroups: View{

    @Environment(\.presentationMode) var presentationMode
    
    var body: some View{
        Spacer()
        Text("Aww Shucks, this page hasn't been developed yet! \n \n Maybe if we had more funding ;(")
            .pretty()
        Spacer()
        Button{
            presentationMode.wrappedValue.dismiss()
        } label: {
            Text("CLOSE")
        }.pretty()
    }
}
