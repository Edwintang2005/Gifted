//
//  ListView.swift
//  Gifted
//
//  Created by Edwin Tang on 4/12/2022.
//

import Amplify
import Combine
import SwiftUI

struct ListView: View {
    @EnvironmentObject var sessionManager: SessionManager
    @State var listitems = [ListItem]()
    
    @State var observationToken: AnyCancellable?
    @State var showAddToList = false
    
    
    var body: some View {
        NavigationView{
            ZStack {
                VStack {
                    List {
                        ForEach(listitems) {
                            Item in Text("Item: " + (Item.Name ?? "") + "!")
                        }
                        .onDelete(perform: deleteItem)
                    }
                    HStack(spacing: 10) {
                        Image(uiImage: UIImage(named: "WishlistLoading.jpg") ?? .init())
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 70, height: 70)
                            .clipped()
                            .mask { RoundedRectangle(cornerRadius: 8, style: .continuous) }
                        VStack(alignment: .leading) {
                            Text("New York City")
                                .font(.system(size: 16, weight: .medium, design: .default))
                            Text("$20000")
                        }
                        .font(.subheadline)
                        Spacer()
                        // Navigation to ItemDetailsView
                        NavigationLink(destination: ItemDetailsView()) {
                            Image(systemName: "ellipsis")
                                .foregroundColor(Color(.displayP3, red: 234/255, green: 76/255, blue: 97/255))
                                .font(.title3)
                        }
                        
                    }
                    .padding(.bottom)
                    HStack(spacing: 10) {
                        Image(uiImage: UIImage(named: "WishlistLoading.jpg") ?? .init())
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 70, height: 70)
                            .clipped()
                            .mask { RoundedRectangle(cornerRadius: 8, style: .continuous) }
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Palm Springs")
                                .font(.system(size: 16, weight: .medium, design: .default))
                            Text("$1201")
                        }
                        .font(.subheadline)
                        Spacer()
                        Image(systemName: "ellipsis")
                            .foregroundColor(Color(.displayP3, red: 234/255, green: 76/255, blue: 97/255))
                            .font(.title3)
                    }
                    .padding(.bottom)
                    HStack {
                        Image(uiImage: UIImage(named: "WishlistLoading.jpg") ?? .init())
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 70, height: 70)
                            .clipped()
                            .mask { RoundedRectangle(cornerRadius: 8, style: .continuous) }
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Lisbon")
                                .font(.system(size: 16, weight: .medium, design: .default))
                            Text("$1111")
                        }
                        .font(.subheadline)
                        Spacer()
                        Image(systemName: "ellipsis")
                            .foregroundColor(Color(.displayP3, red: 234/255, green: 76/255, blue: 97/255))
                            .font(.title3)
                    }
                }
                .padding(.horizontal)
                VStack{
                    Spacer()
                    HStack{
                        Spacer()
                        Button{
                            showAddToList.toggle()
                        } label: {
                            Image(systemName: "plus.circle.fill")
                        }
                        .font(.system(size:80))
                        .shadow(color: .gray, radius: 0.2, x: 1, y: 1)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationBarTitle("My List")
            .sheet(isPresented: $showAddToList) {
                AddToList()
            }
        }
        .onAppear{
            getListItem()
            observeListItem()
        }
    }
    
    func getListItem(){
        Amplify.DataStore.query(ListItem.self) { result in
            switch result {
            case.success(let listitems):
                print(listitems)
                self.listitems = listitems
            case.failure(let error):
                print(error)
            }
        }
    }
    
    func observeListItem() {
        observationToken = Amplify.DataStore.publisher(for: ListItem.self).sink(
            receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print(error)
                }
            },
            receiveValue: { changes in
                // decoding recieved model
                guard let item = try? changes.decodeModel(as: ListItem.self) else {return}
                
                switch changes.mutationType{
                    
                case "create":
                    self.listitems.append(item)
                    
                case "delete":
                    if let index = self.listitems.firstIndex(of: item) {
                        self.listitems.remove(at: index)
                    }
                default:
                    break
                }
                
            }
            
        )
        
    }
    
    func deleteItem(indexSet: IndexSet) {
        print("Deleted item at \(indexSet)")
        
        var updatedItems = listitems
        updatedItems.remove(atOffsets: indexSet)
        
        guard let item = Set(updatedItems).symmetricDifference(listitems).first else {return}
        
        Amplify.DataStore.delete(item) { result in
            switch result {
            case .success:
                print("Deleted Item")
            case .failure(let error):
                print("could not delete Item - \(error)")
            }
        }
    }
    
}



//struct ListView_Previews: PreviewProvider {
//    static var previews: some View {
//        ListView()
//    }
//}
