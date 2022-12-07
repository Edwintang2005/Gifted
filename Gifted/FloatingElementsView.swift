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
            Text("Enter a Short Description for the item:").small()
            TextEditor(text: $description)
                .pretty()
                .lineLimit(3)
            Text("Select an image for this Item:").small()
            ZStack{
                Rectangle()
                    .fill(.secondary)
                Text("Tap to Select an image")
                image?
                    .resizable()
                    .scaledToFit()
            }
            .onTapGesture{
                showingImagePicker = true
            }
            Button{
                saveListItem()
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
    func saveListItem() {
        print(name)
        let item = ListItem(id: UUID().uuidString,
                            Name: name,
                            Price: price,
                            Link: link,
                            ShortDescription: description,
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
