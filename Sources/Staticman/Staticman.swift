import Foundation
import SwiftMarkdown
import Yams

/// StaticItem structure
public struct StaticItem: Encodable {

  public var title: String
  public var status: String
  public var slug: String
  public var date: String
  public var entry: String

}

public struct Staticman {

  var directory: String = ""

  /// Initialize
  public init(directory: String) {

    self.directory = directory

  }

  /// Returns a list of content items
  public func items() throws -> [StaticItem] {

    return try! self.getItems()

  }

  /// Returns a single content item
  public func item(slug: String) throws -> StaticItem {

    return try! self.getItem(slug: slug)

  }

  /// Returns a single random item, except the one passed as `slug` (if provided)
  public func randomItem(exceptWithSlug: String? = nil) throws -> StaticItem {

    let items = try! self.getItems()

    if exceptWithSlug != nil {

      var itemsWithoutException: [StaticItem] = []

      for item in items {

        if item.slug != exceptWithSlug && item.status != "private" {

          itemsWithoutException.append(item)

        }

      }

      return itemsWithoutException.randomElement()!

    } else {

      return items.randomElement()!

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
  private func getItems() throws -> [StaticItem] {

    let contentFiles = try self.getContentFiles() 
    let parsedContent = try self.parseContentFiles(files: contentFiles)
    let sortedContent = try self.sortContentByDateDesc(content: parsedContent)
    var items: [StaticItem] = []

    for item in sortedContent {

      let yaml = item["yaml"] as! [String: Any]
      let title = yaml["title"] as! String
      let status = yaml["status"] as! String
      let slug = yaml["slug"] as! String
      let date = yaml["date"] as! Date
      let timeAgo = self.relativeTime(datetime: date)
      let entry = item["entry"] as! String

      items.append(StaticItem(title: title, status: status, slug: slug, date: timeAgo, entry: entry))

    }

    return items

  }

  /// Get content item
  private func getItem(slug: String) throws -> StaticItem {

    let items = try self.getItems()
    var item: StaticItem!

    for i in items {

      if i.slug == slug {

        item = i

      }

    }

    return item

  }

  /// This is merely a helper fn that returns a "s" when the `n` is more than 1
  private func sStrOptional(n: Int) -> String {

    if n > 1 {

      return "s"

    }

    return ""

  }

  /**
   Turns a timestamp string into a relative time.
   
   - Parameter datetime: Datetime string.
   
   - Returns: String.
   */
  private func relativeTime(datetime: Date) -> String {
    
    let currentTimestamp = Date().currentTimeMillis()
    let timestamp = datetime.currentTimeMillis()
    let difference: Int = currentTimestamp - timestamp
    let minute: Int = 60 * 1000
    let hour: Int = minute * 60
    let day: Int = hour * 24
    let month: Int = day * 30
    let year: Int = day * 365
    
    if(difference < minute) {
        
      let s: String = self.sStrOptional(n: difference / 1000)
      let seconds: String = String(difference / 1000)
      
      return seconds + " second" + s + " ago"
        
    } else if(difference < hour) {
      
      let s: String = self.sStrOptional(n: difference / minute)
      let minutes: String = String(difference / minute)
      
      return minutes + " minute" + s + " ago"
      
    } else if(difference < day) {
        
      let s: String = self.sStrOptional(n: difference / hour)
      let hours: String = String(difference / hour)
      
      return hours + " hour" + s + " ago"
        
    } else if(difference < month) {
        
      let s: String = self.sStrOptional(n: difference / day)
      let days: String = String(difference / day)
      
      return days + " day" + s + " ago"
        
    } else if(difference < year) {
      
      let s: String = self.sStrOptional(n: difference / month)
      let months: String = String(difference / month)
      
      return months + " month" + s + " ago"
        
    } else {
        
      return "Years"
       
    }
      
  }

}

extension Date {

  // Get current Epoch time
  func currentTimeMillis() -> Int {
        
    return Int(self.timeIntervalSince1970 * 1000)
      
  }

  /// Convert Date to String, in a given `dateFormat`
  func toString(dateFormat format: String) -> String {

    let dateFormatter = DateFormatter()

    dateFormatter.dateFormat = format

    return dateFormatter.string(from: self)

  }

}