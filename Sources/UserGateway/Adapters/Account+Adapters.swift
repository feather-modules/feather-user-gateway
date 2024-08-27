import FeatherComponent
import FeatherDatabase
import FeatherModuleKit
import FeatherValidation
import NanoID
import SystemModuleKit
import UserGatewayDatabaseKit
import UserGatewayKit
import UserModuleKit

extension User.Account.List.Query.Sort.Keys {
    init(type: UserGateway.Account.List.Query.Sort.Keys) {
        switch type {
        case .email:
            self = .email
        }
    }
}
