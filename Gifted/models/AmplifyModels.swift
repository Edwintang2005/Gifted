// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "4abbe7c5bd478ddb3655c84c3ba918c2"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: List.self)
    ModelRegistry.register(modelType: ListItem.self)
    ModelRegistry.register(modelType: Reservations.self)
    ModelRegistry.register(modelType: Group.self)
    ModelRegistry.register(modelType: User.self)
    ModelRegistry.register(modelType: ListListItem.self)
  }
}