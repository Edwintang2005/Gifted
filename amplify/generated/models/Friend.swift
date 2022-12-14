// swiftlint:disable all
import Amplify
import Foundation

public struct Friend: Model {
  public let id: String
  public var Username: String
  public var OwnerUser: String
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      Username: String,
      OwnerUser: String) {
    self.init(id: id,
      Username: Username,
      OwnerUser: OwnerUser,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      Username: String,
      OwnerUser: String,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.Username = Username
      self.OwnerUser = OwnerUser
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}