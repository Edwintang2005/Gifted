// swiftlint:disable all
import Amplify
import Foundation

extension UserList {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case userID
    case Name
    case ListItems
    case BackgroundImageKey
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let userList = UserList.keys
    
    model.authRules = [
      rule(allow: .public, operations: [.create, .update, .delete, .read])
    ]
    
    model.pluralName = "UserLists"
    
    model.attributes(
      .primaryKey(fields: [userList.id])
    )
    
    model.fields(
      .field(userList.id, is: .required, ofType: .string),
      .field(userList.userID, is: .required, ofType: .string),
      .field(userList.Name, is: .required, ofType: .string),
      .field(userList.ListItems, is: .required, ofType: .embeddedCollection(of: String.self)),
      .field(userList.BackgroundImageKey, is: .optional, ofType: .string),
      .field(userList.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(userList.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension UserList: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}