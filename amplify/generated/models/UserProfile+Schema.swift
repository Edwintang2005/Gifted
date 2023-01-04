// swiftlint:disable all
import Amplify
import Foundation

extension UserProfile {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case Username
    case Name
    case ImageKey
    case Lists
    case Friends
    case Groups
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let userProfile = UserProfile.keys
    
    model.authRules = [
      rule(allow: .public, operations: [.create, .update, .delete, .read])
    ]
    
    model.pluralName = "UserProfiles"
    
    model.attributes(
      .primaryKey(fields: [userProfile.id])
    )
    
    model.fields(
      .field(userProfile.id, is: .required, ofType: .string),
      .field(userProfile.Username, is: .required, ofType: .string),
      .field(userProfile.Name, is: .required, ofType: .string),
      .field(userProfile.ImageKey, is: .optional, ofType: .string),
      .field(userProfile.Lists, is: .required, ofType: .embeddedCollection(of: String.self)),
      .field(userProfile.Friends, is: .required, ofType: .embeddedCollection(of: String.self)),
      .field(userProfile.Groups, is: .required, ofType: .embeddedCollection(of: String.self)),
      .field(userProfile.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(userProfile.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension UserProfile: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}