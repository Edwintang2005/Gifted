// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "2cc80db90d11c520d42959398a1a1701"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: UserProfile.self)
    ModelRegistry.register(modelType: UserList.self)
    ModelRegistry.register(modelType: ListItem.self)
    ModelRegistry.register(modelType: Group.self)
    ModelRegistry.register(modelType: Reservations.self)
  }
}