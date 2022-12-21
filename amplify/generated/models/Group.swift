// swiftlint:disable all
import Amplify
import Foundation

public struct Group: Model {
  public let id: String
  public var ShortID: String
  public var Name: String
  public var NameAndShortID: String
  public var Members: [String]
  public var ImageKey: String?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      ShortID: String,
      Name: String,
      NameAndShortID: String,
      Members: [String] = [],
      ImageKey: String? = nil) {
    self.init(id: id,
      ShortID: ShortID,
      Name: Name,
      NameAndShortID: NameAndShortID,
      Members: Members,
      ImageKey: ImageKey,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      ShortID: String,
      Name: String,
      NameAndShortID: String,
      Members: [String] = [],
      ImageKey: String? = nil,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.ShortID = ShortID
      self.Name = Name
      self.NameAndShortID = NameAndShortID
      self.Members = Members
      self.ImageKey = ImageKey
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}