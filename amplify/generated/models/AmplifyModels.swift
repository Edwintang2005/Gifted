// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "f17a0c8f844c26a01610fb9b35edb6aa"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: ListItem.self)
    ModelRegistry.register(modelType: User.self)
  }
}