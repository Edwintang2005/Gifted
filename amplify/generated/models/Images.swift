// swiftlint:disable all
import Amplify
import Foundation

public struct Images: Model {
  public let id: String
  public var imageKey: String
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      imageKey: String) {
    self.init(id: id,
      imageKey: imageKey,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      imageKey: String,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.imageKey = imageKey
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}