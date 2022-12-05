// swiftlint:disable all
import Amplify
import Foundation

extension UserGroup {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case user
    case group
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let userGroup = UserGroup.keys
    
    model.pluralName = "UserGroups"
    
    model.attributes(
      .index(fields: ["userId"], name: "byUser"),
      .index(fields: ["groupId"], name: "byGroup"),
      .primaryKey(fields: [userGroup.id])
    )
    
    model.fields(
      .field(userGroup.id, is: .required, ofType: .string),
      .belongsTo(userGroup.user, is: .required, ofType: User.self, targetNames: ["userId"]),
      .belongsTo(userGroup.group, is: .required, ofType: Group.self, targetNames: ["groupId"]),
      .field(userGroup.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(userGroup.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension UserGroup: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}