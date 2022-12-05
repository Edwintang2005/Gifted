// swiftlint:disable all
import Amplify
import Foundation

public struct User: Model {
  public let id: String
  public var Email: String?
  public var Password: String
  public var ListItems: List<ListItem>?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      Email: String? = nil,
      Password: String,
      ListItems: List<ListItem>? = []) {
    self.init(id: id,
      Email: Email,
      Password: Password,
      ListItems: ListItems,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      Email: String? = nil,
      Password: String,
      ListItems: List<ListItem>? = [],
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.Email = Email
      self.Password = Password
      self.ListItems = ListItems
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}