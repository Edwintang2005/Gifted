// swiftlint:disable all
import Amplify
import Foundation

public struct ListItem: Model {
  public let id: String
  public var Link: String?
  public var Price: String?
  public var ShortDescription: String?
  public var userID: String
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      Link: String? = nil,
      Price: String? = nil,
      ShortDescription: String? = nil,
      userID: String) {
    self.init(id: id,
      Link: Link,
      Price: Price,
      ShortDescription: ShortDescription,
      userID: userID,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      Link: String? = nil,
      Price: String? = nil,
      ShortDescription: String? = nil,
      userID: String,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.Link = Link
      self.Price = Price
      self.ShortDescription = ShortDescription
      self.userID = userID
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}