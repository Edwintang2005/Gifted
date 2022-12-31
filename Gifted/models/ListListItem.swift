// swiftlint:disable all
import Amplify
import Foundation

public struct ListListItem: Model {
  public let id: String
  public var list: List
  public var listItem: ListItem
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      list: List,
      listItem: ListItem) {
    self.init(id: id,
      list: list,
      listItem: listItem,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      list: List,
      listItem: ListItem,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.list = list
      self.listItem = listItem
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}