// swiftlint:disable all
import Amplify
import Foundation

public struct User: Model {
  public let id: String
  public var Username: String
  public var Friends: [String]
  public var Groups: [String]
  public var Lists: List<List>?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      Username: String,
      Friends: [String] = [],
      Groups: [String] = [],
      Lists: List<List>? = []) {
    self.init(id: id,
      Username: Username,
      Friends: Friends,
      Groups: Groups,
      Lists: Lists,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      Username: String,
      Friends: [String] = [],
      Groups: [String] = [],
      Lists: List<List>? = [],
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.Username = Username
      self.Friends = Friends
      self.Groups = Groups
      self.Lists = Lists
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}