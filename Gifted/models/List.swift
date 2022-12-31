// swiftlint:disable all
import Amplify
import Foundation

public struct List: Model {
  public let id: String
  public var Name: String
  public var BackgroundImageKey: String?
  public var userID: String
  public var ListItems: List<ListListItem>?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      Name: String,
      BackgroundImageKey: String? = nil,
      userID: String,
      ListItems: List<ListListItem>? = []) {
    self.init(id: id,
      Name: Name,
      BackgroundImageKey: BackgroundImageKey,
      userID: userID,
      ListItems: ListItems,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      Name: String,
      BackgroundImageKey: String? = nil,
      userID: String,
      ListItems: List<ListListItem>? = [],
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.Name = Name
      self.BackgroundImageKey = BackgroundImageKey
      self.userID = userID
      self.ListItems = ListItems
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}