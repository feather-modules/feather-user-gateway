//
//  File.swift
//
//
//  Created by Viasz-Kádi Ferenc on 03/02/2024.
//

import FeatherACL
import FeatherModuleKit
import SystemModuleKit 

extension Permission {

    static func user(_ context: String, action: Action) -> Self {
        .init(namespace: "user-gateway", context: context, action: action)
    }
}

public enum User {

    public enum ACL: ACLSet {

        public static var all: [FeatherACL.Permission] {
            Account.ACL.all
        }
    }
    
    public enum Error: Swift.Error {
        case unknown
        case invalidPassword
        case invalidAuthToken
        case invalidInvitationToken
        case invalidPasswordResetToken
        case invalidAccount
    }

    public enum Account: Identifiable {}
    public enum Role: Identifiable {}
}

public protocol UserGatewayInterface: ModuleInterface {

    var account: UserAccountInterface { get }
}
