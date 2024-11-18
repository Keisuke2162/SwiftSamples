import Foundation

extension String {
  public func toDate() -> Date? {
    let dateFormatter = ISO8601DateFormatter()
    return dateFormatter.date(from: self)
  }

  // 文字列から数値のみ取り出す
  public func extractNumericPart() -> String {
    let pattern = #"^\d+(\.\d+)?|\d+(?=%)"#
    let regex = try? NSRegularExpression(pattern: pattern)
    
    if let match = regex?.firstMatch(in: self, range: NSRange(self.startIndex..., in: self)) {
      return String(self[Range(match.range, in: self)!])
    }
    return ""
  }
}
