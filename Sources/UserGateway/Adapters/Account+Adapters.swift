import FeatherComponent
import FeatherDatabase
import FeatherModuleKit
import FeatherValidation
import NanoID
import SystemModuleKit
import UserGatewayAccountsKit
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

extension Components.Parameters.UserAccountListSort {
    init(by: UserGateway.Account.List.Query.Sort.Keys) {
        switch by {
        case .email:
            self = .email
        }
    }
}

extension Components.Parameters.FeatherCoreListOrder {
    init(order: Order) {
        switch order {
        case .asc:
            self = .asc
        case .desc:
            self = .desc
        }
    }
}
