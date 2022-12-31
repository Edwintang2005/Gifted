// swiftlint:disable all
import Amplify
import Foundation

public struct UserList: Model {
  public let id: String
  public var userID: String
  public var Name: String
  public var ListItems: [String]
  public var BackgroundImageKey: String?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      userID: String,
      Name: String,
      ListItems: [String] = [],
      BackgroundImageKey: String? = nil) {
    self.init(id: id,
      userID: userID,
      Name: Name,
      ListItems: ListItems,
      BackgroundImageKey: BackgroundImageKey,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      userID: String,
      Name: String,
      ListItems: [String] = [],
      BackgroundImageKey: String? = nil,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.userID = userID
      self.Name = Name
      self.ListItems = ListItems
      self.BackgroundImageKey = BackgroundImageKey
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}