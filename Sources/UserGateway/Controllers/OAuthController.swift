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

struct OAuthController: UserGatewayOAuthInterface {
    let components: ComponentRegistry
    let user: UserGatewayInterface
    let oauthClient: Client

    public init(
        components: ComponentRegistry,
        user: UserGatewayInterface,
        oauthClient: Client
    ) {
        self.components = components
        self.user = user
        self.oauthClient = oauthClient
    }

    // MARK: -
    func getJWT(_ request: UserGateway.OAuth.JwtRequest) async throws
        -> UserGateway.OAuth.JwtResponse
    {
        let ret = try await oauthClient.tokenReturnOauthAuth(
            body: .urlEncodedForm(
                .init(
                    grant_type: request.grantType?.rawValue,
                    client_id: request.clientId,
                    client_secret: request.clientSecret,
                    code: request.code,
                    redirect_uri: request.redirectUri
                )
            )
        )

        switch ret {
        case .ok(let response):
            switch response.body {
            case .json(let data):
                return .init(
                    accessToken: data.access_token,
                    tokenType: data.token_type,
                    expiresIn: data.expires_in,
                    scope: data.scope
                )
            }

        case .badRequest(_):
            throw UserGateway.OauthError.invalidGrant

        case .unauthorized(_):
            throw UserGateway.Error.unknown

        case .forbidden(_):
            throw UserGateway.OauthError.unauthorizedClient

        case .undocumented(_, _):
            throw UserGateway.Error.unknown

        case .conflict(_):
            throw UserGateway.Error.unknown
        }
    }
}
