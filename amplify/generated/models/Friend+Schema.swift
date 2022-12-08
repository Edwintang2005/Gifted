// swiftlint:disable all
import Amplify
import Foundation

extension Friend {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case Username
    case OwnerUser
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let friend = Friend.keys
    
    model.authRules = [
      rule(allow: .public, operations: [.create, .update, .delete, .read])
    ]
    
    model.pluralName = "Friends"
    
    model.attributes(
      .primaryKey(fields: [friend.id])
    )
    
    model.fields(
      .field(friend.id, is: .required, ofType: .string),
      .field(friend.Username, is: .optional, ofType: .string),
      .field(friend.OwnerUser, is: .required, ofType: .string),
      .field(friend.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(friend.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension Friend: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}