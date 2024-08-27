import FeatherOpenAPIKit
import Foundation
import Yams

for document in documents {
    let encoder = YAMLEncoder()
    
    do {
        let openAPIDocument = try document.openAPIDocument()
        _ = try openAPIDocument.locallyDereferenced()
        
        let yaml = try encoder.encode(openAPIDocument)
        let basePath = #file
            .split(separator: "/")
            .dropLast(3)
            .joined(separator: "/")
        
        let paths = [
            "/\(basePath)/\(document.path)/openapi.yaml",
            "/\(basePath)/Sources/\(document.kitPath)/openapi.yaml",
        ]
        
        for path in paths {
            try yaml.write(
                to: URL(fileURLWithPath: path),
                atomically: true,
                encoding: .utf8
            )
        }
    }
    catch {
        fatalError("\(error)")
    }
}
