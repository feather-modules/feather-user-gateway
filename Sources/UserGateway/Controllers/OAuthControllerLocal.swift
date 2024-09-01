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

struct OAuthControllerLocal: UserGatewayOAuthInterface {
    let components: ComponentRegistry
    let user: UserGatewayInterface

    public init(
        components: ComponentRegistry,
        user: UserGatewayInterface
    ) {
        self.components = components
        self.user = user
    }

    // MARK: -
    func getJWT(_ request: UserGateway.OAuth.JwtRequest) async throws -> UserGateway.OAuth.JwtResponse {
        throw User.Error.unknown
    }
}
