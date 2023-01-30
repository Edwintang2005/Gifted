//
//  AddToList.swift
//  Gifted
//
//  Created by Edwin Tang on 5/1/2023.
//

import Amplify
import SwiftUI

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
    
    
    //Variables for getting image input
    @State var showingImagePicker = false
    @State var inputImage: UIImage?
    @State var image: Image?
    
    var body: some View{
        
        VStack(alignment: .center) {
            Spacer()
            TextField("Name", text: $name).pretty()
            TextField("Link", text: $link).pretty()
                .keyboardType(.URL)
            TextField("Price", text: $price).pretty()
                .keyboardType(.decimalPad) // enforces number input for prices
            ZStack(alignment: .center){
                if (image == nil) {
                    RoundedRectangle(cornerRadius: 7, style: .continuous)
                        .fill(.white)
                        .border(Color(.sRGB, red: 217/255, green: 217/255, blue: 217/255), width: 1)
                    Text("Tap to Select an image").itemText()
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
                            ImageKey: UserDefaults.standard.string(forKey: "ImageKey"),
                            Link: link)
        let completion = dataStore.createListItem(item: item, list: lists[listNumber])
        if completion {
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    // Function that saves image input if exists in the database Storage
    func StoreImage(_ image: UIImage?) {

        let data = Data()
        let image = UIImage(data: data)
        
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

//struct AddToList_Previews: PreviewProvider {
//    static var previews: some View {
//        AddToList()
//    }
//}
