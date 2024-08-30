import FeatherComponent
import FeatherDatabase
import FeatherModuleKit
import FeatherValidation
import Foundation
import NanoID
import SystemModuleKit
import UserGatewayAccountsKit
import UserGatewayDatabaseKit
import UserGatewayKit
import UserModuleKit

extension ModuleError {
    init?(_ notFoundError: Components.Schemas.FeatherCoreNotFoundError) {
        let str = notFoundError.key

        let pattern = #"objectNotFound\(model: "(.*?)", keyName: "(.*?)"\)"#
        let regex = try? NSRegularExpression(pattern: pattern, options: [])

        guard
            let matches = regex?
                .firstMatch(
                    in: str,
                    options: [],
                    range: NSRange(str.startIndex..., in: str)
                ),
            matches.numberOfRanges == 3
        else {
            return nil
        }

        if let modelRange = Range(matches.range(at: 1), in: str),
            let keyNameRange = Range(matches.range(at: 2), in: str)
        {
            let model = String(str[modelRange])
            let keyName = String(str[keyNameRange])

            self = .objectNotFound(model: model, keyName: keyName)
            return
        }

        return nil
    }
}

extension ValidatorError {
    init(
        _ unprocessableContentError: Components.Schemas
            .FeatherCoreUnprocessableContentError
    ) {
        self.init(
            failures: unprocessableContentError.failures.map {
                .init(key: $0.key, message: $0.message)
            }
        )
    }
}

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
