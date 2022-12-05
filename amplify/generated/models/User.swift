// swiftlint:disable all
import Amplify
import Foundation

public struct User: Model {
  public let id: String
  public var Name: [String?]?
  public var Email: String?
  public var Groups: List<UserGroup>?
  public var ListItems: List<ListItem>?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      Name: [String?]? = nil,
      Email: String? = nil,
      Groups: List<UserGroup>? = [],
      ListItems: List<ListItem>? = []) {
    self.init(id: id,
      Name: Name,
      Email: Email,
      Groups: Groups,
      ListItems: ListItems,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      Name: [String?]? = nil,
      Email: String? = nil,
      Groups: List<UserGroup>? = [],
      ListItems: List<ListItem>? = [],
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.Name = Name
      self.Email = Email
      self.Groups = Groups
      self.ListItems = ListItems
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}