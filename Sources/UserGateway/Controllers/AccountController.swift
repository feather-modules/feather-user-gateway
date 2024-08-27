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
import UserGatewayAccountsKit

struct AccountController: UserAccountInterface
{
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

    func create(
        _ input: User.Account.Create
    ) async throws -> User.Account.Detail {
        let ret = try await accountsClient.createUserAccount(.init(body: .json(.init(email: input.email,
                                                             password: input.password,
                                                             roleKeys: [],
                                                            permissions: [])))).ok.body.json
                                                         
        return .init(id: .init(rawValue: ret.id), email: ret.email, roles: [], permissions: [])
    }

    func require(
        _ id: FeatherModuleKit.ID<User.Account>
    ) async throws -> User.Account.Detail {
        fatalError()
    }

    func update(
        _ id: ID<User.Account>,
        _ input: User.Account.Update
    ) async throws -> User.Account.Detail {
        fatalError()
    }

    func patch(
        _ id: ID<User.Account>,
        _ input: User.Account.Patch
    ) async throws -> User.Account.Detail {
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
