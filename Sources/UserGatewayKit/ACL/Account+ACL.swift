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

        public static let list: Permission = .userAccount(.list)
        public static let meDetail: Permission = .userAccount(
            .custom("me_detail")
        )
        public static let meUpdate: Permission = .userAccount(
            .custom("me_update")
        )
        public static let mePatch: Permission = .userAccount(
            .custom("me_patch")
        )

        public static var all: [Permission] = [
            list.self,
            meDetail.self,
            meUpdate.self,
            mePatch.self,
        ]
    }
}
