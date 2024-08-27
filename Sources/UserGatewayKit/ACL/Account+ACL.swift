//
//  File.swift
//
//
//  Created by Tibor Bodecs on 20/02/2024.
//

import FeatherACL

extension Permission {

    static func userAccount(_ action: Action) -> Self {
        .userGateway("account", action: action)
    }
}

extension UserGateway.Account {

    public enum ACL: ACLSet {

        public static var all: [Permission] = []
    }
}
