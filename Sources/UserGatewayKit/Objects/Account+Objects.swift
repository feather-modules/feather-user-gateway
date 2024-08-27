//
//  File.swift
//
//
//  Created by Viasz-Kádi Ferenc on 03/02/2024.
//

import FeatherModuleKit
import SystemModuleKit

extension User.Account {

    public struct Reference: Object {
        public let id: ID<User.Account>
        public let email: String

        public init(
            id: ID<User.Account>,
            email: String
        ) {
            self.id = id
            self.email = email
        }
    }

    public struct List: ListInterface {

        public struct Query: ListQueryInterface {

            public struct Sort: ListQuerySortInterface {

                public enum Keys: SortKeyInterface {
                    case email
                }

                public let by: Keys
                public let order: Order

                public init(by: Keys, order: Order) {
                    self.by = by
                    self.order = order
                }
            }

            public let search: String?
            public let sort: Sort
            public let page: Page

            public init(
                search: String? = nil,
                sort: User.Account.List.Query.Sort,
                page: Page
            ) {
                self.search = search
                self.sort = sort
                self.page = page
            }
        }

        public struct Item: Object {
            public let id: ID<User.Account>
            public let email: String

            public init(
                id: ID<User.Account>,
                email: String
            ) {
                self.id = id
                self.email = email
            }
        }

        public let items: [Item]
        public let count: UInt

        public init(
            items: [User.Account.List.Item],
            count: UInt
        ) {
            self.items = items
            self.count = count
        }

    }

    public struct Detail: Object {
        public let id: ID<User.Account>
        public let email: String
        public let roles: [User.Role.Reference]
        public let permissions: [ID<System.Permission>]

        public init(
            id: ID<User.Account>,
            email: String,
            roles: [User.Role.Reference],
            permissions: [ID<System.Permission>]
        ) {
            self.id = id
            self.email = email
            self.roles = roles
            self.permissions = permissions
        }
    }

    public struct Create: Object {
        public let email: String
        public let password: String
        public let roleKeys: [ID<User.Role>]
        public let permissions: [ID<System.Permission>]

        public init(
            email: String,
            password: String,
            roleKeys: [ID<User.Role>] = [],
            permissions: [ID<System.Permission>] = []
        ) {
            self.email = email
            self.password = password
            self.roleKeys = roleKeys
            self.permissions = permissions
        }

    }

    public struct Update: Object {
        public let email: String
        public let password: String?
        public let roleKeys: [ID<User.Role>]

        public init(
            email: String,
            password: String? = nil,
            roleKeys: [ID<User.Role>]
        ) {
            self.email = email
            self.password = password
            self.roleKeys = roleKeys
        }
    }

    public struct Patch: Object {
        public let email: String?
        public let password: String?
        public let roleKeys: [ID<User.Role>]?

        public init(
            email: String? = nil,
            password: String? = nil,
            roleKeys: [ID<User.Role>]? = nil
        ) {
            self.email = email
            self.password = password
            self.roleKeys = roleKeys
        }
    }
}
