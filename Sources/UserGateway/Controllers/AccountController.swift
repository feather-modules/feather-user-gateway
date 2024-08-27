//
//  File.swift
//
//
//  Created by Tibor Bodecs on 04/02/2024.
//

import FeatherComponent
import FeatherDatabase
import FeatherModuleKit
import Logging
import NanoID
import UserGatewayAccountsKit
import UserGatewayDatabaseKit
import UserGatewayKit
import UserModuleKit

struct AccountController: UserGatewayAccountInterface {
    let components: ComponentRegistry
    let user: UserGatewayInterface
    let accountsClient: Client

    public init(
        components: ComponentRegistry,
        user: UserGatewayInterface,
        accountsClient: Client
    ) {
        self.components = components
        self.user = user
        self.accountsClient = accountsClient
    }

    // MARK: -

    func require(
        _ id: ID<User.Account>
    ) async throws -> UserGateway.Account.Detail {
        fatalError()
    }

    func update(
        _ id: ID<User.Account>,
        _ input: UserGateway.Account.Update
    ) async throws -> UserGateway.Account.Detail {
        fatalError()
    }

    func patch(
        _ id: ID<User.Account>,
        _ input: UserGateway.Account.Patch
    ) async throws -> UserGateway.Account.Detail {
        fatalError()
    }

    func list(_ input: UserGateway.Account.List.Query) async throws
        -> UserGateway.Account.List
    {
        fatalError()
    }

    func reference(ids: [ID<User.Account>])
        async throws -> [UserGateway.Account.Reference]
    {
        fatalError()
    }
}
