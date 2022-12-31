// swiftlint:disable all
import Amplify
import Foundation

extension ListListItem {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case list
    case listItem
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let listListItem = ListListItem.keys
    
    model.pluralName = "ListListItems"
    
    model.attributes(
      .index(fields: ["listId"], name: "byList"),
      .index(fields: ["listItemId"], name: "byListItem"),
      .primaryKey(fields: [listListItem.id])
    )
    
    model.fields(
      .field(listListItem.id, is: .required, ofType: .string),
      .belongsTo(listListItem.list, is: .required, ofType: List.self, targetNames: ["listId"]),
      .belongsTo(listListItem.listItem, is: .required, ofType: ListItem.self, targetNames: ["listItemId"]),
      .field(listListItem.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(listListItem.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension ListListItem: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}