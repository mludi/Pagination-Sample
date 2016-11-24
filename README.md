# VaporSimplePagination-Sample
## [VaporSimplePagination - Github](https://github.com/mludi/VaporSimplePagination)


## How to use

### Installation Guide Server

1) Clone the project via
    <pre>git clone https://github.com/mludi/Pagination-Sample</pre>

2) cd project-folder/server
    
3) create `mysql.json` inside _Config_ or _Config/secrets_ folder and enter your mysql credentials like

```json
{
    "host": "localhost",
    "user": "root",
    "password": "",
    "database": "ml-sample"
}
```

4) Run `vapor build && vapor run serve` to install dependencies and run the server


### iOS Sample

1) cd project-folder/Client

2) open `Client.xcodeproj`

3) Run the project and you are done :]

Node: Set delay in `Webservice.posts(currentPage: currentPage, withDelay: 1) { [weak self] (inPosts, inTotalPages, inTotalPosts, inError) in` to <b>0</b> to have normal networking, I just installed the possibility to see pagination with "slower" network in action.



