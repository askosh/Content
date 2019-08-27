import Foundation
import SwiftMarkdown
import Yams

/// ContentItem structure
struct ContentItem: Encodable {

  var title: String
  var status: String
  var slug: String
  var date: String
  var entry: String

}

class Content {

  var directory: String = ""

  /// Initialize
  init(directory: String) {

    self.directory = directory

  }

  /// Returns a list of content items
  func items() throws -> [ContentItem] {

    return try! self.getItems()

  }

  /// Returns a single content item
  func item(slug: String) throws -> ContentItem {

    return try! self.getItem(slug: slug)

  }

  /// Returns a single random item, except the one passed as `slug` (if provided)
  func randomItem(exceptWithSlug: String? = nil) throws -> ContentItem {

    let items = try! self.getItems()

    if exceptWithSlug != nil {

      var itemsWithoutException: [ContentItem] = []

      for item in items {

        if item.slug != exceptWithSlug && item.status != "private" {

          itemsWithoutException.append(item)

        }

      }

      return itemsWithoutException.randomElement()!

    } else {

      return items

    }

  }


  /// Get content files from the specified directory
  private func getContentFiles() throws -> [String] {

    let fileManager = FileManager()
    let files = try! fileManager.contentsOfDirectory(atPath: self.directory)
    var markdownFiles: [String] = []

    /// Only get files that are markdown files
    for filename in files {

      if filename.hasSuffix(".md") {

        markdownFiles.append(filename)

      }

    }

    return markdownFiles

  }

  /// Parse content files
  private func parseContentFiles(files: [String]) throws -> [[String: Any]] {

    var items: [[String: Any]] = []

    for filename in files {

      let fileContent = try String(contentsOfFile: self.directory + filename, encoding: String.Encoding.utf8)

      /// Get YAML data
      if let yamlRange = fileContent.range(of: "(?s)(?<=---\n).*(?=\n---)", options: .regularExpression) {

        let yamlRangeResult = String(fileContent[yamlRange])
        let yamlData = try Yams.load(yaml: yamlRangeResult) as? [String: Any] ?? [:]

        // Get content, and parse it as markdown
        if let contentRange = fileContent.range(of: "(?s)(?<=\n---).*", options: .regularExpression) {

          let contentRangeResult = String(fileContent[contentRange])
          let contentData = try markdownToHTML(contentRangeResult)

          items.append(["yaml": yamlData, "entry": contentData])
          
        }

      }

    }

    return items

  }

  /// Sort content by date yaml key, in descending order
  private func sortContentByDateDesc(content: [[String: Any]]) throws -> [[String: Any]] {
    
    let sortedContent = content.sorted(by: { (x, y) in

      let yamlA = x["yaml"] as! [String: Any]
      let yamlB = y["yaml"] as! [String: Any]
      let dateA = yamlA["date"] as! Date
      let dateB = yamlB["date"] as! Date

      return dateA > dateB


    })

    return sortedContent

  }

  /// Get content items
  private func getItems() throws -> [ContentItem] {

    let contentFiles = try self.getContentFiles() 
    let parsedContent = try self.parseContentFiles(files: contentFiles)
    let sortedContent = try self.sortContentByDateDesc(content: parsedContent)
    var items: [ContentItem] = []

    for item in sortedContent {

      let yaml = item["yaml"] as! [String: Any]
      let title = yaml["title"] as! String
      let status = yaml["status"] as! String
      let slug = yaml["slug"] as! String
      let date = yaml["date"] as! Date
      let timeAgo = Utils().relativeTime(datetime: date)
      let entry = item["entry"] as! String

      items.append(ContentItem(title: title, status: status, slug: slug, date: timeAgo, entry: entry))

    }

    return items

  }

  /// Get content item
  private func getItem(slug: String) throws -> ContentItem {

    let items = try self.getItems()
    var item: ContentItem!

    for i in items {

      if i.slug == slug {

        item = i

      }

    }

    return item

  }

}