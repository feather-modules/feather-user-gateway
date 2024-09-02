//
//  File.swift
//
//
//  Created by Tibor Bodecs on 21/02/2024.
//

import FeatherModuleKit
import UserModuleKit

public protocol UserGatewayAccountInterface: Sendable {

    func list(
        _ input: UserGateway.Account.List.Query
    ) async throws -> UserGateway.Account.List

    func reference(
        ids: [ID<User.Account>]
    ) async throws -> [UserGateway.Account.Reference]

    func require(
        _ id: ID<User.Account>
    ) async throws -> UserGateway.Account.Detail
}
