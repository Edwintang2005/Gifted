// swiftlint:disable all
import Amplify
import Foundation

public struct ListItem: Model {
  public let id: String
  public var Name: String
  public var Price: String
  public var ImageKey: String?
  public var Link: String?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      Name: String,
      Price: String,
      ImageKey: String? = nil,
      Link: String? = nil) {
    self.init(id: id,
      Name: Name,
      Price: Price,
      ImageKey: ImageKey,
      Link: Link,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      Name: String,
      Price: String,
      ImageKey: String? = nil,
      Link: String? = nil,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.Name = Name
      self.Price = Price
      self.ImageKey = ImageKey
      self.Link = Link
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}