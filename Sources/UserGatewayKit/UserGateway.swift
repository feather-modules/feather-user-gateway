//
//  File.swift
//
//
//  Created by Viasz-Kádi Ferenc on 03/02/2024.
//

import FeatherACL
import FeatherModuleKit
import HTTPTypes
import OpenAPIRuntime

extension Permission {

    static func userGateway(_ context: String, action: Action) -> Self {
        .init(namespace: "user-gateway", context: context, action: action)
    }
}

public enum UserGateway {

    public enum AlwaysThrowingGateway {}

    public enum ACL: ACLSet {

        public static var all: [FeatherACL.Permission] {
            Account.ACL.all
        }
    }

    public enum OauthError: Swift.Error {
        case invalidGrant
        case unauthorizedClient
    }

    public enum Error: Swift.Error {
        case unknown
        case endpointUnreachable
        case httpResponse(HTTPResponse, HTTPBody?)
    }

    public enum Account: Identifiable {}
    public enum Role: Identifiable {}
    public enum OAuth: Identifiable {}
}

public protocol UserGatewayInterface: ModuleInterface {

    var account: UserGatewayAccountInterface { get }
}
