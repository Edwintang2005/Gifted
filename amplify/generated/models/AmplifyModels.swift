// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "df7f8194b6618e18035a32a8badb2d4c"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: UserProfile.self)
    ModelRegistry.register(modelType: UserList.self)
    ModelRegistry.register(modelType: ListItem.self)
    ModelRegistry.register(modelType: Group.self)
    ModelRegistry.register(modelType: Reservations.self)
  }
}