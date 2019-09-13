# Staticman

**Staticman** is a static content engine written in Swift, for Swift projects. It powers my [personal site](https://asko.sh) and is meant to be used for sites with static content, such as blogs or websites, either as a complimentary addition or the sole thing driving it - that's for you to decide.

### Example content file

All of the content files in **Staticman** are Markdown files. That means they have a file name of `example.md`. They can be in any directory you want (you can specify it) and they contain YAML metadata. An example of a Staticman file is the following (probably a familiar format if you've used Jekyll before):

```
---
date: 2019-02-18
status: public
slug: example-url-slug
title: Example page
---

Example content in **Markdown** goes here.
```

This would create the following `StaticItem` object: 

```Swift
public struct StaticItem: Encodable {

  public var meta: [String: String]
  public var entry: String

}
```

Currently all of these are required, but I will probably make some of these optional in a later release.

### Installation

To install Staticman, simply require it in your Package.swift file like this:

```Swift
dependencies: [
  .package(url: "https://github.com/askosh/staticman.git", from: "1.0.7")
]
```

### Usage

#### Retrieving all content in a directory

To retrieve all of the Staticman content in a directory, simply initialize Staticman with your provided directory and call `items()` on it, like this:

```Swift
import Staticman

let content = Staticman(directory: "./Blog/")
let items = try content.items()
```

This will return you an array of `StaticItem` objects.

#### Retreving a specific item in a directory

To retrieve a specific Staticman content in a directory, initialize Staticman and call `item(slug: String)` on it (where slug is corresponding with the YAML key `slug` in the file), like this:

```Swift
import Staticman

let content = Staticman(directory: "./Blog/")
let item = try content.item(slug: "hello-world")
```

This will return you a `StaticItem` object.

#### Retrieving a random item in a directory

To retrieve a random Staticman content in a directory, initialize Staticman and call `randomItem` on it, like this:

```Swift
import Staticman

let content = Staticman(directory: "./Blog/")
let item = try content.randomItem()
```

This will return you a `StaticItem` object.

You can also optionally pass it an argument `exceptWithSlug: String`, which would return a random item except the one provided in the slug (where slug is corresponding with the YAML key `slug` in the file), like this:

```Swift
import Staticman

let content = Staticman(directory: "./Blog/")
let item = try content.randomItem(exceptWithSlug: "hello-world")
```

This will return you random a `StaticItem` object from the specified directory, except the one specified with the `exceptWithSlug: String` parameter.