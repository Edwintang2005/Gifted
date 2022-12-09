// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "ecf5b5656b72e73137b8c9571ab50a93"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: GroupLink.self)
    ModelRegistry.register(modelType: Friend.self)
    ModelRegistry.register(modelType: Group.self)
    ModelRegistry.register(modelType: ListItem.self)
  }
}