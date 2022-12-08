// swiftlint:disable all
import Amplify
import Foundation

public struct Group: Model {
  public let id: String
  public var Name: String?
  public var Members: [String?]?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      Name: String? = nil,
      Members: [String?]? = nil) {
    self.init(id: id,
      Name: Name,
      Members: Members,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      Name: String? = nil,
      Members: [String?]? = nil,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.Name = Name
      self.Members = Members
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}