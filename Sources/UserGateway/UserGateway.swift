import FeatherComponent
import FeatherModuleKit
import Logging
import SystemModuleKit
import UserGatewayKit
import UserGatewayAccountsKit
import OpenAPIRuntime
import Foundation
import UserModuleKit

public struct UserGatewayClientInit {
    let serverURL: URL
    let configuration: Configuration
    let transport: any ClientTransport
    let middlewares: [any ClientMiddleware]
    
    public init(
        serverURL: URL,
        configuration: Configuration = .init(),
        transport: any ClientTransport,
        middlewares: [any ClientMiddleware] = []
    ) {
        self.serverURL = serverURL
        self.configuration = configuration
        self.transport = transport
        self.middlewares = middlewares
    }
}

public struct UserGatewayAccountsInit {
    public struct Config {
        public init() {}
    }
    
    let accountsClientInit: UserGatewayClientInit?
    let userModuleInit: UserModuleInterface?
    let config: Config
    
    public init(
        accountsClientInit: UserGatewayClientInit,
        config: Config = .init()
    ) {
        self.accountsClientInit = accountsClientInit
        self.userModuleInit = nil
        self.config = config
    }
    
    public init(
        userModuleInit: UserModuleInterface,
        config: Config = .init()
    ) {
        self.accountsClientInit = nil
        self.userModuleInit = userModuleInit
        self.config = config
    }
}

struct UserGatewayAccountsProxy: Sendable {
    let accountsClient: UserGatewayAccountsKit.Client?
    let userModule: UserModuleInterface?
    
    public init(
        accountsGatewayInit: UserGatewayAccountsInit
    ) {
        if let accountsClientInit = accountsGatewayInit.accountsClientInit {
            self.accountsClient = .init(serverURL: accountsClientInit.serverURL,
                                    configuration: accountsClientInit.configuration, //+ custom configuration
                                    transport: accountsClientInit.transport,
                                    middlewares: accountsClientInit.middlewares //+ custom Middlewares
            )
        }
        else {
            self.accountsClient = nil
        }
        
        if let userModule = accountsGatewayInit.userModuleInit {
            self.userModule = userModule
        }
        else {
            self.userModule = nil
        }
    }
}

public struct UserGateway: UserGatewayInterface {
    public let system: SystemModuleInterface
    let components: ComponentRegistry
    let logger: Logger
    let accountsProxy: UserGatewayAccountsProxy

    public init(
        system: SystemModuleInterface,
        components: ComponentRegistry,
        accountsGatewayInit: UserGatewayAccountsInit,
        logger: Logger = .init(label: "user-gateway")
    ) {
        self.system = system
        self.components = components
        self.logger = logger
        self.accountsProxy = .init(accountsGatewayInit: accountsGatewayInit)
    }

    public var account: UserGatewayKit.UserAccountInterface {
        if let userModule = accountsProxy.userModule {
            return AccountControllerLocal(
                components: components,
                user: self,
                userModule: userModule
            )
        }
        
        return AccountController(
            components: components,
            user: self,
            accountsClient: accountsProxy.accountsClient!
        )
    }
}
