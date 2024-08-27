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
import UserGatewayDatabaseKit
import UserGatewayKit
import UserModuleKit

struct AccountControllerLocal: UserGatewayAccountInterface {
    let components: ComponentRegistry
    let user: UserGatewayInterface
    let userModule: UserModuleInterface

    public init(
        components: ComponentRegistry,
        user: UserGatewayInterface,
        userModule: UserModuleInterface
    ) {
        self.components = components
        self.user = user
        self.userModule = userModule
    }

    // MARK: -

    func require(
        _ id: ID<User.Account>
    ) async throws -> UserGateway.Account.Detail {
        let ret = try await userModule.account.require(id)

        return .init(
            id: ret.id,
            email: ret.email,
            roles: ret.roles.map { .init(key: $0.key, name: $0.name) },
            permissions: ret.permissions
        )
    }

    func update(
        _ id: ID<User.Account>,
        _ input: UserGateway.Account.Update
    ) async throws -> UserGateway.Account.Detail {
        let ret = try await userModule.account.update(
            id,
            .init(
                email: input.email,
                password: input.password,
                roleKeys: input.roleKeys
            )
        )

        return .init(
            id: ret.id,
            email: ret.email,
            roles: ret.roles.map { .init(key: $0.key, name: $0.name) },
            permissions: ret.permissions
        )
    }

    func patch(
        _ id: ID<User.Account>,
        _ input: UserGateway.Account.Patch
    ) async throws -> UserGateway.Account.Detail {
        let ret = try await userModule.account.patch(
            id,
            .init(
                email: input.email,
                password: input.password,
                roleKeys: input.roleKeys
            )
        )

        return .init(
            id: ret.id,
            email: ret.email,
            roles: ret.roles.map { .init(key: $0.key, name: $0.name) },
            permissions: ret.permissions
        )
    }

    func list(_ input: UserGateway.Account.List.Query) async throws
        -> UserGateway.Account.List
    {
        let ret = try await userModule.account.list(
            .init(
                search: input.search,
                sort: .init(
                    by: .init(type: input.sort.by),
                    order: input.sort.order
                ),
                page: input.page
            )

        )

        return .init(
            items: ret.items.map {
                .init(id: $0.id, email: $0.email)
            },
            count: ret.count
        )
    }

    func reference(ids: [ID<User.Account>])
        async throws -> [UserGateway.Account.Reference]
    {
        let ret = try await userModule.account.reference(ids: ids)

        return ret.map {
            .init(id: $0.id, email: $0.email)
        }
    }
}
