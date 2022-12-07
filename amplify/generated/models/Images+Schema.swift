// swiftlint:disable all
import Amplify
import Foundation

extension Images {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case imageKey
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let images = Images.keys
    
    model.authRules = [
      rule(allow: .public, operations: [.create, .update, .delete, .read])
    ]
    
    model.pluralName = "Images"
    
    model.attributes(
      .primaryKey(fields: [images.id])
    )
    
    model.fields(
      .field(images.id, is: .required, ofType: .string),
      .field(images.imageKey, is: .required, ofType: .string),
      .field(images.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(images.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension Images: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}