// swiftlint:disable all
import Amplify
import Foundation

public struct Reservations: Model {
  public let id: String
  public var OwnerUser: String
  public var ItemID: String
  public var ReservedBy: [String]?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      OwnerUser: String,
      ItemID: String,
      ReservedBy: [String]? = nil) {
    self.init(id: id,
      OwnerUser: OwnerUser,
      ItemID: ItemID,
      ReservedBy: ReservedBy,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      OwnerUser: String,
      ItemID: String,
      ReservedBy: [String]? = nil,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.OwnerUser = OwnerUser
      self.ItemID = ItemID
      self.ReservedBy = ReservedBy
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}