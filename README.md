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

### Installation

To install Staticman, simply require it in your Package.swift file like this:

```Swift
dependencies: [
  .package(url: "https://github.com/askosh/staticman.git", from: "1.0.6")
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

#### Retreving a specific item in a directory

To retrieve a specific Staticman content in a directory, initialize Staticman and call `item(slug: String)` on it (where slug is corresponding with the YAML key `slug` in the file), like this:

```Swift
import Staticman

let content = Staticman(directory: "./Blog/")
let item = try content.item(slug: "hello-world")
```

### Retrieving a random item in a directory

To retrieve a random Staticman content in a directory, initialize Staticman and call `randomItem` on it, like this:

```Swift
import Staticman

let content = Staticman(directory: "./Blog/")
let item = try content.randomItem()
```

You can also optionally pass it an argument `exceptWithSlug: String`, which would return a random item except the one provided in the slug (where slug is corresponding with the YAML key `slug` in the file), like this:

```Swift
import Staticman

let content = Staticman(directory: "./Blog/")
let item = try content.randomItem(exceptWithSlug: "hello-world")
```
