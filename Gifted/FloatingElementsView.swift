//
//  FloatingElementsView.swift
//  Gifted
//
//  Created by Edwin Tang on 4/12/2022.
//

import SwiftUI
import Amplify

//Floating Button used in Friends
struct Floating_Button_Friends: View{

    var body: some View{
        Button{
            print("Floating Button Test")
        } label: {
            Image(systemName: "plus.circle.fill")
        }
        .font(.system(size:80))
        .shadow(color: .gray, radius: 0.2, x: 1, y: 1)
        Spacer(minLength: 1200)
        }
    }


//Floating Button used in List
struct AddToList: View{

    @Environment(\.presentationMode) var presentationMode
    @State var name = String()
    
    var body: some View{
        VStack{
            Text("Enter a New Item")
                .pretty()
            TextEditor(text: $name)
                .padding(.all)
            Button{
                saveListItem()
                
            } label: {
                    Text("Save")
                }.pretty()
        }
        .padding(.horizontal)
    }
    func saveListItem() {
        print(name)
        let item = ListItem(Name: name, userID: "1")
        
        Amplify.DataStore.save(item) { result in
            switch result {
            case .success:
                print("Saved Item")
                
            case .failure(let error):
                print(error)
            }
        }
        presentationMode.wrappedValue.dismiss()
    }
}


//Floating Button used in Groups
struct Floating_Button_Groups: View{

    var body: some View{
        Button{
            print("Floating Button Test")
        } label: {
            Image(systemName: "plus.circle.fill")
        }
        .font(.system(size:80))
        .shadow(color: .gray, radius: 0.2, x: 1, y: 1)
        Spacer(minLength: 1200)
        }
    

    }
