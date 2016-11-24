import Vapor
import Fluent
import VaporMySQL
import VaporSimplePagination

let drop = Droplet()

try drop.addProvider(VaporMySQL.Provider)
drop.preparations.append(Post.self)


drop.group("api") { api in
    api.group("v1") { v1 in
        v1.get("posts") { request in
            guard let page = request.data["page"]?.int else {
                return try JSON(Post.all().makeNode())
            }
            guard let json = Post.paginate(limit: 10, page: page, description: "posts", makeJSON: false) else {
                throw Abort.badRequest
            }
            return try JSON(node: json)
        }
        v1.post("posts") { request in
            guard let content = request.data["content"]?.string else {
                throw Abort.custom(status: .badRequest, message: "missing value")
            }
            var post = Post(content: content)
            try post.save()
            return post
        }
    }
    
}

drop.run()
