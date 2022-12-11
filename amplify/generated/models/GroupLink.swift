// swiftlint:disable all
import Amplify
import Foundation

public struct GroupLink: Model {
  public let id: String
  public var GroupID: String
  public var GroupName: String
  public var OwnerUser: String?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      GroupID: String,
      GroupName: String,
      OwnerUser: String? = nil) {
    self.init(id: id,
      GroupID: GroupID,
      GroupName: GroupName,
      OwnerUser: OwnerUser,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      GroupID: String,
      GroupName: String,
      OwnerUser: String? = nil,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.GroupID = GroupID
      self.GroupName = GroupName
      self.OwnerUser = OwnerUser
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}