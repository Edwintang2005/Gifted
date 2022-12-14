// swiftlint:disable all
import Amplify
import Foundation

extension ListItem {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case Name
    case Price
    case ShortDescription
    case ImageKey
    case Link
    case Reservation
    case userID
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let listItem = ListItem.keys
    
    model.authRules = [
      rule(allow: .public, operations: [.create, .update, .delete, .read])
    ]
    
    model.pluralName = "ListItems"
    
    model.attributes(
      .primaryKey(fields: [listItem.id])
    )
    
    model.fields(
      .field(listItem.id, is: .required, ofType: .string),
      .field(listItem.Name, is: .required, ofType: .string),
      .field(listItem.Price, is: .optional, ofType: .string),
      .field(listItem.ShortDescription, is: .optional, ofType: .string),
      .field(listItem.ImageKey, is: .optional, ofType: .string),
      .field(listItem.Link, is: .optional, ofType: .string),
      .field(listItem.Reservation, is: .optional, ofType: .embeddedCollection(of: String.self)),
      .field(listItem.userID, is: .required, ofType: .string),
      .field(listItem.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(listItem.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension ListItem: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}