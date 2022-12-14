// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "de7fb2b2e667e60c91ff2d9b6b667dff"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: ListItem.self)
    ModelRegistry.register(modelType: Friend.self)
    ModelRegistry.register(modelType: GroupLink.self)
    ModelRegistry.register(modelType: Group.self)
  }
}