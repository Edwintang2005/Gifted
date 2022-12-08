// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "b8aebc943439498f7013a4eff16e1f09"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: Group.self)
    ModelRegistry.register(modelType: ListItem.self)
    ModelRegistry.register(modelType: User.self)
  }
}