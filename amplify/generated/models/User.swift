// swiftlint:disable all
import Amplify
import Foundation

public struct User: Model {
  public let id: String
  public var Username: String?
  public var ListItems: List<ListItem>?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      Username: String? = nil,
      ListItems: List<ListItem>? = []) {
    self.init(id: id,
      Username: Username,
      ListItems: ListItems,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      Username: String? = nil,
      ListItems: List<ListItem>? = [],
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.Username = Username
      self.ListItems = ListItems
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}