// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "f69ebcf4c90d5bd5add2a57a36446eff"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: Reservations.self)
    ModelRegistry.register(modelType: Group.self)
    ModelRegistry.register(modelType: User.self)
    ModelRegistry.register(modelType: ListItem.self)
  }
}