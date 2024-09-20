//
//  File.swift
//
//
//  Created by Tibor Bodecs on 04/02/2024.
//

import FeatherComponent
import FeatherDatabase
import FeatherModuleKit
import FeatherValidation
import Logging
import NanoID
import UserGatewayAccountsKit
import UserGatewayDatabaseKit
import UserGatewayKit
import UserModuleKit

struct AccountController: UserGatewayAccountInterface {
    let components: ComponentRegistry
    let user: UserGatewayInterface
    let accountClient: Client

    public init(
        components: ComponentRegistry,
        user: UserGatewayInterface,
        accountClient: Client
    ) {
        self.components = components
        self.user = user
        self.accountClient = accountClient
    }

    // MARK: -

    func require(
        _ id: ID<User.Account>
    ) async throws -> UserGateway.Account.Detail {
        let ret: Operations.detailUserGatewayAccounts.Output

        do {
            ret = try await accountClient.detailUserGatewayAccounts(
                .init(path: .init(accountId: id.rawValue))
            )
        }
        catch {
            throw UserGateway.Error.endpointUnreachable
        }

        switch ret {
        case .ok(let response):
            switch response.body {
            case .json(let data):
                return .init(
                    id: .init(rawValue: data.id),
                    email: data.email,
                    firstName: data.firstName,
                    lastName: data.lastName,
                    imageKey: data.imageKey,
                    roles: data.roles.map {
                        .init(key: .init(rawValue: $0.key), name: $0.name)
                    },
                    permissions: data.permissions.map { .init(rawValue: $0) }

                )
            }

        case .badRequest(let response):
            try UserGatewayModule.throwResponse(response)

        case .unauthorized(let response):
            try UserGatewayModule.throwResponse(response)

        case .forbidden(let response):
            try UserGatewayModule.throwResponse(response)

        case .notFound(let response):
            switch response.body {
            case .json(let data):
                if let error = ModuleError(data) {
                    throw error
                }
            }
            try UserGatewayModule.throwResponse(response)

        case .undocumented(let code, let response):
            try UserGatewayModule.throwResponse(code, response)
        }

        throw UserGateway.Error.unknown
    }

    func list(_ input: UserGateway.Account.List.Query) async throws
        -> UserGateway.Account.List
    {
        let ret: Operations.listUserGatewayAccounts.Output

        do {
            ret = try await accountClient.listUserGatewayAccounts(
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
        }
        catch {
            throw UserGateway.Error.endpointUnreachable
        }

        switch ret {
        case .ok(let response):
            switch response.body {
            case .json(let data):
                return .init(
                    items: data.items.map {
                        .init(
                            id: .init(rawValue: $0.id),
                            email: $0.email,
                            firstName: $0.firstName,
                            lastName: $0.lastName,
                            imageKey: $0.imageKey
                        )
                    },
                    count: UInt(data.count)
                )
            }

        case .badRequest(let response):
            try UserGatewayModule.throwResponse(response)

        case .unauthorized(let response):
            try UserGatewayModule.throwResponse(response)

        case .forbidden(let response):
            try UserGatewayModule.throwResponse(response)

        case .undocumented(let code, let response):
            try UserGatewayModule.throwResponse(code, response)
        }

        throw UserGateway.Error.unknown
    }

    func reference(ids: [ID<User.Account>])
        async throws -> [UserGateway.Account.Reference]
    {
        let ret: Operations.referenceUserGatewayAccounts.Output

        do {
            ret = try await accountClient.referenceUserGatewayAccounts(
                .init(body: .json(ids.map { $0.rawValue }))
            )
        }
        catch {
            throw UserGateway.Error.endpointUnreachable
        }

        switch ret {
        case .ok(let response):
            switch response.body {
            case .json(let data):
                return data.map {
                    .init(
                        id: .init(rawValue: $0.id),
                        email: $0.email,
                        firstName: $0.firstName,
                        lastName: $0.lastName,
                        imageKey: $0.imageKey
                    )
                }
            }

        case .badRequest(let response):
            try UserGatewayModule.throwResponse(response)

        case .unauthorized(let response):
            try UserGatewayModule.throwResponse(response)

        case .forbidden(let response):
            try UserGatewayModule.throwResponse(response)

        case .notFound(let response):
            switch response.body {
            case .json(let data):
                if let error = ModuleError(data) {
                    throw error
                }
            }
            try UserGatewayModule.throwResponse(response)

        case .unsupportedMediaType(let response):
            try UserGatewayModule.throwResponse(response)

        case .unprocessableContent(let unprocessableContentResponse):
            switch unprocessableContentResponse.body {
            case .json(let data):
                throw ValidatorError(data)
            }

        case .undocumented(let code, let response):
            try UserGatewayModule.throwResponse(code, response)
        }

        throw UserGateway.Error.unknown
    }
}
