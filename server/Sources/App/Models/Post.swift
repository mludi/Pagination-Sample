import Vapor
import Fluent
import Foundation

final class Post: Model {
    var id: Node?
    var content: String
    var exists: Bool = false
    
    init(content: String) {
        self.content = content
    }

    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        content = try node.extract("content")
    }

    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "content": content
        ])
    }
    
    func makeJSON() throws -> JSON {
        return try JSON(node: [
            "id": id,
            "content": "\(content) 😱"
        ])
    }
}

extension Post {
    public convenience init?(from string: String) throws {
        self.init(content: string)
    }
}

extension Post: Preparation {
    static func prepare(_ database: Database) throws {
        try drop.database?.create("posts") { posts in
            posts.id()
            posts.string("content")
        }
    }

    static func revert(_ database: Database) throws {
        try drop.database?.delete("posts")
    }
}
