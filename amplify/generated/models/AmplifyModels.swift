// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "845336f4704e1eed9a67ca421fb40a47"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: Group.self)
    ModelRegistry.register(modelType: GroupLink.self)
    ModelRegistry.register(modelType: Friend.self)
    ModelRegistry.register(modelType: ListItem.self)
  }
}