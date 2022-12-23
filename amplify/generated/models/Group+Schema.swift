// swiftlint:disable all
import Amplify
import Foundation

extension Group {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case Name
    case ShortID
    case NameAndShortID
    case Members
    case ImageKey
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let group = Group.keys
    
    model.authRules = [
      rule(allow: .public, operations: [.create, .update, .delete, .read])
    ]
    
    model.pluralName = "Groups"
    
    model.attributes(
      .primaryKey(fields: [group.id])
    )
    
    model.fields(
      .field(group.id, is: .required, ofType: .string),
      .field(group.Name, is: .required, ofType: .string),
      .field(group.ShortID, is: .required, ofType: .string),
      .field(group.NameAndShortID, is: .required, ofType: .string),
      .field(group.Members, is: .required, ofType: .embeddedCollection(of: String.self)),
      .field(group.ImageKey, is: .optional, ofType: .string),
      .field(group.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(group.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension Group: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}