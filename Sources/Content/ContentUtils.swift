import Foundation

class ContentUtils {

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
  public func relativeTime(datetime: Date) -> String {
    
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