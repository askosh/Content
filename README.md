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