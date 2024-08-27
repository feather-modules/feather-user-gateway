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

struct AccountControllerLocal: UserGatewayKit.UserAccountInterface
{
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

    func create(
        _ input: UserGatewayKit.User.Account.Create
    ) async throws -> UserGatewayKit.User.Account.Detail {
        let ret = try await userModule.account.create(
            .init(email: input.email, password: input.password, roleKeys: input.roleKeys.map{ $0.transform(to: User.Role.self) })
        )
        
        return .init(id: ret.id.transform(to: UserGatewayKit.User.Account.self),
                     email: ret.email,
                     roles: ret.roles.map{ .init(key: $0.key.transform(to: UserGatewayKit.User.Role.self), name: $0.name) },
                     permissions: [])
    }

    func require(
        _ id: FeatherModuleKit.ID<UserGatewayKit.User.Account>
    ) async throws -> UserGatewayKit.User.Account.Detail {
        fatalError()
    }

    func update(
        _ id: ID<UserGatewayKit.User.Account>,
        _ input: UserGatewayKit.User.Account.Update
    ) async throws -> UserGatewayKit.User.Account.Detail {
        fatalError()
    }

    func patch(
        _ id: ID<UserGatewayKit.User.Account>,
        _ input: UserGatewayKit.User.Account.Patch
    ) async throws -> UserGatewayKit.User.Account.Detail {
        fatalError()
    }
    
    func list(_ input: UserGatewayKit.User.Account.List.Query) async throws -> UserGatewayKit.User.Account.List {
        fatalError()
    }
    
    func reference(ids: [FeatherModuleKit.ID<UserGatewayKit.User.Account>]) async throws -> [UserGatewayKit.User.Account.Reference] {
        fatalError()
    }
    
    func bulkDelete(ids: [FeatherModuleKit.ID<UserGatewayKit.User.Account>]) async throws {
        fatalError()
    }
}
