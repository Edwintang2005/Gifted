// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "2ab361843924fb49e975c8659b56d2ac"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: GroupLink.self)
    ModelRegistry.register(modelType: Friend.self)
    ModelRegistry.register(modelType: Group.self)
    ModelRegistry.register(modelType: ListItem.self)
  }
}