// swiftlint:disable all
import Amplify
import Foundation

public struct UserList: Model {
  public let id: String
  public var userID: String
  public var Name: String
  public var ListItems: [String]
  public var ImageKey: String?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      userID: String,
      Name: String,
      ListItems: [String] = [],
      ImageKey: String? = nil) {
    self.init(id: id,
      userID: userID,
      Name: Name,
      ListItems: ListItems,
      ImageKey: ImageKey,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      userID: String,
      Name: String,
      ListItems: [String] = [],
      ImageKey: String? = nil,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.userID = userID
      self.Name = Name
      self.ListItems = ListItems
      self.ImageKey = ImageKey
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}