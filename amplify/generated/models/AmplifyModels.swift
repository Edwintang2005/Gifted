// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "5daa4abd1cd896cd1ed71f0354843928"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: Friend.self)
    ModelRegistry.register(modelType: Group.self)
    ModelRegistry.register(modelType: ListItem.self)
  }
}