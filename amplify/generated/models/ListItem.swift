// swiftlint:disable all
import Amplify
import Foundation

public struct ListItem: Model {
  public let id: String
  public var Name: String?
  public var Link: String?
  public var Price: Double?
  public var userID: String
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      Name: String? = nil,
      Link: String? = nil,
      Price: Double? = nil,
      userID: String) {
    self.init(id: id,
      Name: Name,
      Link: Link,
      Price: Price,
      userID: userID,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      Name: String? = nil,
      Link: String? = nil,
      Price: Double? = nil,
      userID: String,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.Name = Name
      self.Link = Link
      self.Price = Price
      self.userID = userID
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}