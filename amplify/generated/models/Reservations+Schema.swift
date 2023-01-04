// swiftlint:disable all
import Amplify
import Foundation

extension Reservations {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case OwnerUser
    case ItemID
    case ReservedBy
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let reservations = Reservations.keys
    
    model.authRules = [
      rule(allow: .public, operations: [.create, .update, .delete, .read])
    ]
    
    model.pluralName = "Reservations"
    
    model.attributes(
      .primaryKey(fields: [reservations.id])
    )
    
    model.fields(
      .field(reservations.id, is: .required, ofType: .string),
      .field(reservations.OwnerUser, is: .required, ofType: .string),
      .field(reservations.ItemID, is: .required, ofType: .string),
      .field(reservations.ReservedBy, is: .required, ofType: .embeddedCollection(of: String.self)),
      .field(reservations.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(reservations.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension Reservations: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}