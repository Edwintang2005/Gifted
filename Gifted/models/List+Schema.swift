// swiftlint:disable all
import Amplify
import Foundation

extension List {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case Name
    case BackgroundImageKey
    case userID
    case ListItems
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let list = List.keys
    
    model.authRules = [
      rule(allow: .public, operations: [.create, .update, .delete, .read])
    ]
    
    model.pluralName = "Lists"
    
    model.attributes(
      .index(fields: ["userID"], name: "byUser"),
      .primaryKey(fields: [list.id])
    )
    
    model.fields(
      .field(list.id, is: .required, ofType: .string),
      .field(list.Name, is: .required, ofType: .string),
      .field(list.BackgroundImageKey, is: .optional, ofType: .string),
      .field(list.userID, is: .required, ofType: .string),
      .hasMany(list.ListItems, is: .optional, ofType: ListListItem.self, associatedWith: ListListItem.keys.list),
      .field(list.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(list.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension List: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}