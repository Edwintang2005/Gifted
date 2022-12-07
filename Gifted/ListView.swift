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
    
    var body: some View {
        ZStack {
            
            List {
                ForEach(filterItem(listed: listitems)) {
                    Item in NavigationLink{
                        ItemDetailsView(listItem: Item)
                    } label: {
                        Text( Item.Name ?? " " ).listtext()
                    }
                }
                .onDelete(perform: deleteItem)
            }
            VStack{
                Spacer()
                HStack{
                    Spacer()
                    NavigationLink{
                        AddToList()
                    } label: {
                            Image(systemName: "plus.circle.fill").floaty()
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarTitle("My List")
//        .sheet(isPresented: $showAddToList) {
//            AddToList()
//        }
        .onAppear{
            observeListItem()
            getListItem()
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
    
    func filterItem(listed: [ListItem]) -> [ListItem] {
        return listed.filter {Item in
            Item.userID == UserDefaults.standard.string(forKey: "Username")
        }

    }
}



//struct ListView_Previews: PreviewProvider {
//    static var previews: some View {
//        ListView()
//    }
//}
