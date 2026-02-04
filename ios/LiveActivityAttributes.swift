import ActivityKit
import Foundation

struct LiveActivityAttributes: ActivityAttributes {
  struct ContentState: Codable, Hashable {
    var caption: String
    var title: String
    var subtitle: String
    var teamLogoLeft: String
    var teamLogoRight: String
    var teamScoreLeft: Int
    var teamScoreRight: Int
    var teamNameLeft: String
    var teamNameRight: String
  }

  var name: String
  var gradientStartColor: String?
  var gradientEndColor: String?
  var titleColor: String?
  var subtitleColor: String?
  var deepLinkUrl: String?
}
