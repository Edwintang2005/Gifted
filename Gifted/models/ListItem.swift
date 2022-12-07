// swiftlint:disable all
import Amplify
import Foundation

public struct ListItem: Model {
  public let id: String
  public var Name: String?
  public var Price: String?
  public var Link: String?
  public var ShortDescription: String?
  public var userID: String
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      Name: String? = nil,
      Price: String? = nil,
      Link: String? = nil,
      ShortDescription: String? = nil,
      userID: String) {
    self.init(id: id,
      Name: Name,
      Price: Price,
      Link: Link,
      ShortDescription: ShortDescription,
      userID: userID,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      Name: String? = nil,
      Price: String? = nil,
      Link: String? = nil,
      ShortDescription: String? = nil,
      userID: String,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.Name = Name
      self.Price = Price
      self.Link = Link
      self.ShortDescription = ShortDescription
      self.userID = userID
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}