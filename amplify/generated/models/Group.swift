// swiftlint:disable all
import Amplify
import Foundation

public struct Group: Model {
  public let id: String
  public var users: List<UserGroup>?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      users: List<UserGroup>? = []) {
    self.init(id: id,
      users: users,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      users: List<UserGroup>? = [],
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.users = users
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}