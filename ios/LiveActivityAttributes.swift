import ActivityKit
import Foundation

struct LiveActivityAttributes: ActivityAttributes {
  struct ContentState: Codable, Hashable {
    var title: String
    var subtitle: String?
    var teamLogoLeft: String?
    var teamLogoRight: String?
    var teamScoreLeft: String?
    var teamScoreRight: String?
    var teamNameLeft: String?
    var teamNameRight: String?
  }

  var name: String
  var backgroundColor: String?
  var titleColor: String?
  var subtitleColor: String?
  var deepLinkUrl: String?
}
