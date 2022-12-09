// swiftlint:disable all
import Amplify
import Foundation

extension GroupLink {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case GroupID
    case GroupName
    case OwnerUser
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let groupLink = GroupLink.keys
    
    model.authRules = [
      rule(allow: .public, operations: [.create, .update, .delete, .read])
    ]
    
    model.pluralName = "GroupLinks"
    
    model.attributes(
      .primaryKey(fields: [groupLink.id])
    )
    
    model.fields(
      .field(groupLink.id, is: .required, ofType: .string),
      .field(groupLink.GroupID, is: .required, ofType: .string),
      .field(groupLink.GroupName, is: .optional, ofType: .string),
      .field(groupLink.OwnerUser, is: .optional, ofType: .string),
      .field(groupLink.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(groupLink.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension GroupLink: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}