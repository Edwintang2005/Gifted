// swiftlint:disable all
import Amplify
import Foundation

public struct UserGroup: Model {
  public let id: String
  public var user: User
  public var group: Group
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      user: User,
      group: Group) {
    self.init(id: id,
      user: user,
      group: group,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      user: User,
      group: Group,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.user = user
      self.group = group
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}