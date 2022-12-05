// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "d1323e8ed3089b9dff4e6dc5187ce84d"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: ListItem.self)
    ModelRegistry.register(modelType: User.self)
    ModelRegistry.register(modelType: Group.self)
    ModelRegistry.register(modelType: UserGroup.self)
  }
}