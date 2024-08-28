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
        let ret =
            try await accountsClient.detailUserGatewayAccounts(
                .init(path: .init(accountId: id.rawValue))
            )
            .ok.body.json

        return .init(
            id: .init(rawValue: ret.id),
            email: ret.email,
            roles: ret.roles.map {
                .init(key: .init(rawValue: $0.key), name: $0.name)
            },
            permissions: ret.permissions.map { .init(rawValue: $0) }
        )
    }

    func update(
        _ id: ID<User.Account>,
        _ input: UserGateway.Account.Update
    ) async throws -> UserGateway.Account.Detail {
        let ret =
            try await accountsClient.updateUserGatewayAccounts(
                .init(
                    path: .init(accountId: id.rawValue),
                    body: .json(
                        .init(
                            email: input.email,
                            password: input.password,
                            roleKeys: input.roleKeys.map { $0.rawValue }
                        )
                    )
                )
            )
            .ok.body.json

        return .init(
            id: .init(rawValue: ret.id),
            email: ret.email,
            roles: ret.roles.map {
                .init(key: .init(rawValue: $0.key), name: $0.name)
            },
            permissions: ret.permissions.map { .init(rawValue: $0) }
        )
    }

    func patch(
        _ id: ID<User.Account>,
        _ input: UserGateway.Account.Patch
    ) async throws -> UserGateway.Account.Detail {
        let ret =
            try await accountsClient.patchUserGatewayAccounts(
                .init(
                    path: .init(accountId: id.rawValue),
                    body: .json(
                        .init(
                            email: input.email,
                            password: input.password,
                            roleKeys: input.roleKeys.map {
                                $0.map { $0.rawValue }
                            }
                        )
                    )
                )
            )
            .ok.body.json

        return .init(
            id: .init(rawValue: ret.id),
            email: ret.email,
            roles: ret.roles.map {
                .init(key: .init(rawValue: $0.key), name: $0.name)
            },
            permissions: ret.permissions.map { .init(rawValue: $0) }
        )
    }

    func list(_ input: UserGateway.Account.List.Query) async throws
        -> UserGateway.Account.List
    {
        let ret =
            try await accountsClient.listUserGatewayAccounts(
                .init(
                    query:
                        .init(
                            sort: .init(by: input.sort.by),
                            search: input.search,
                            pageSize: Int(input.page.size),
                            pageIndex: Int(input.page.index),
                            order: .init(order: input.sort.order)
                        )
                )
            )
            .ok.body.json

        return .init(
            items: ret.items.map {
                .init(id: .init(rawValue: $0.id), email: $0.email)
            },
            count: UInt(ret.count)
        )
    }

    func reference(ids: [ID<User.Account>])
        async throws -> [UserGateway.Account.Reference]
    {
        let ret =
            try await accountsClient.referenceUserGatewayAccounts(
                .init(body: .json(ids.map { $0.rawValue }))
            )
            .ok.body.json

        return ret.map {
            .init(id: .init(rawValue: $0.id), email: $0.email)
        }
    }
}
