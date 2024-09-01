//
//  File.swift
//
//
//  Created by Tibor Bodecs on 21/02/2024.
//

import FeatherModuleKit
import UserModuleKit

public protocol UserGatewayOAuthInterface: Sendable {

    func getJWT(_ request: UserGateway.OAuth.JwtRequest) async throws
                                        -> UserGateway.OAuth.JwtResponse
}
