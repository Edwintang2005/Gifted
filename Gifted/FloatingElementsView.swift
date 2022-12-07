//
//  FloatingElementsView.swift
//  Gifted
//
//  Created by Edwin Tang on 4/12/2022.
//

import SwiftUI
import Amplify

//Floating Button used in Friends
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

//Floating Button used in List
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
                .keyboardType(.decimalPad)
//            Text("Enter a Short Description for the item:").small()
            TextField("Short Description", text: $description).pretty()
//            TextEditor(text: $description)
//                .pretty()
            Text("Select an image for this Item:").small()
            ZStack{
                Rectangle()
                    .fill(.secondary)
                Text("Tap to Select an image").listtext()
                image?
                    .resizable()
                    .scaledToFit()
            }
            .onTapGesture{
                showingImagePicker = true
            }
            Button{
                saveListItem()
                StoreImage(inputImage!)
            } label: {
                    Text("Save")
                }.pretty()
        }
        .padding(.horizontal)
        .navigationTitle("Create a New Item!")
        .onChange(of: inputImage) { _ in loadImage() }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $inputImage)
        }
    }
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
    
    func StoreImage(_ image: UIImage) {
        guard let ImageData = image.jpegData(compressionQuality:0.5) else {return}
        let key = UUID().uuidString + ".jpg"
        @AppStorage("ImageKey") var ImageKey: String = ""
        
        _ = Amplify.Storage.uploadData(key: key, data: ImageData) { result in
            switch result {
            case .success:
                print("Uploaded to DB!")
                ImageKey = key
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


//Floating Button used in Groups
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
