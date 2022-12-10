// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "b24c18844d6a92da4ddc81879f4666e5"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: GroupLink.self)
    ModelRegistry.register(modelType: Friend.self)
    ModelRegistry.register(modelType: Group.self)
    ModelRegistry.register(modelType: ListItem.self)
  }
}