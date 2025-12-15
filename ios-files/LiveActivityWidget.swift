import ActivityKit
import SwiftUI
import WidgetKit

public struct LiveActivityAttributes: ActivityAttributes {
  public struct ContentState: Codable, Hashable {
    var title: String
    var subtitle: String?
    var teamLogoLeft: String?
    var teamLogoRight: String?
    var teamScoreLeft: String?
    var teamScoreRight: String?
    var teamNameLeft: String?
    var teamNameRight: String?

    public init(
      title: String,
      subtitle: String? = nil,
      teamLogoLeft: String? = nil,
      teamLogoRight: String? = nil,
      teamScoreLeft: String? = nil,
      teamScoreRight: String? = nil,
      teamNameLeft: String? = nil,
      teamNameRight: String? = nil
    ) {
      self.title = title
      self.subtitle = subtitle
      self.teamLogoLeft = teamLogoLeft
      self.teamLogoRight = teamLogoRight
      self.teamScoreLeft = teamScoreLeft
      self.teamScoreRight = teamScoreRight
      self.teamNameLeft = teamNameLeft
      self.teamNameRight = teamNameRight
    }
  }

  var name: String
  var backgroundColor: String?
  var titleColor: String?
  var subtitleColor: String?
  var deepLinkUrl: String?

  public init(
    name: String,
    backgroundColor: String? = nil,
    titleColor: String? = nil,
    subtitleColor: String? = nil,
    deepLinkUrl: String? = nil
  ) {
    self.name = name
    self.backgroundColor = backgroundColor
    self.titleColor = titleColor
    self.subtitleColor = subtitleColor
    self.deepLinkUrl = deepLinkUrl
  }
}

@available(iOS 16.1, *)
public struct LiveActivityWidget: Widget {
  public var body: some WidgetConfiguration {
    ActivityConfiguration(for: LiveActivityAttributes.self) { context in
      LiveActivityView(contentState: context.state, attributes: context.attributes)
        .activityBackgroundTint(
          context.attributes.backgroundColor.map { Color(hex: $0) }
        )
        .activitySystemActionForegroundColor(Color.black)
        .applyWidgetURL(from: context.attributes.deepLinkUrl)
    } dynamicIsland: { context in
      DynamicIsland {
        DynamicIslandExpandedRegion(.leading, priority: 1) {
          if let leftLogo = context.state.teamLogoLeft {
            dynamicIslandExpandedTeamLeading(
              teamLogo: leftLogo,
              teamName: context.state.teamNameLeft,
              teamScore: context.state.teamScoreLeft
            )
            .dynamicIsland(verticalPlacement: .belowIfTooWide)
            .padding(.leading, 5)
            .applyWidgetURL(from: context.attributes.deepLinkUrl)
          }
        }
        DynamicIslandExpandedRegion(.center) {
          VStack(spacing: 2) {
            Text(context.state.title)
              .font(.headline)
              .foregroundStyle(.white)
              .fontWeight(.semibold)
            if let subtitle = context.state.subtitle {
              Text(subtitle)
                .font(.caption)
                .foregroundStyle(.white.opacity(0.75))
            }
          }
          .padding(.horizontal, 5)
          .applyWidgetURL(from: context.attributes.deepLinkUrl)
        }
        DynamicIslandExpandedRegion(.trailing) {
          if let rightLogo = context.state.teamLogoRight {
            dynamicIslandExpandedTeamTrailing(
              teamLogo: rightLogo,
              teamName: context.state.teamNameRight,
              teamScore: context.state.teamScoreRight
            )
            .padding(.trailing, 5)
            .applyWidgetURL(from: context.attributes.deepLinkUrl)
          }
        }
      } compactLeading: {
        if let leftLogo = context.state.teamLogoLeft {
          ZStack {
            Circle()
              .fill(.white)
              .frame(width: 26, height: 26)
            resizableImage(imageName: leftLogo)
              .frame(width: 23, height: 23)
          }
          .applyWidgetURL(from: context.attributes.deepLinkUrl)
        }
      } compactTrailing: {
        if let rightLogo = context.state.teamLogoRight {
          ZStack {
            Circle()
              .fill(.white)
              .frame(width: 26, height: 26)
            resizableImage(imageName: rightLogo)
              .frame(width: 23, height: 23)
          }
          .applyWidgetURL(from: context.attributes.deepLinkUrl)
        }
      } minimal: {
        if let leftLogo = context.state.teamLogoLeft, let rightLogo = context.state.teamLogoRight {
          VStack(spacing: 2) {
            ZStack {
              Circle()
                .fill(.white)
                .frame(width: 18, height: 18)
              resizableImage(imageName: leftLogo)
                .frame(width: 16, height: 16)
            }
            ZStack {
              Circle()
                .fill(.white)
                .frame(width: 18, height: 18)
              resizableImage(imageName: rightLogo)
                .frame(width: 16, height: 16)
            }
          }
          .applyWidgetURL(from: context.attributes.deepLinkUrl)
        }
      }
    }
  }

  public init() {}

  private func dynamicIslandExpandedTeamLeading(
    teamLogo: String,
    teamName: String?,
    teamScore: String?
  ) -> some View {
    VStack(spacing: 8) {
      VStack(spacing: 4) {
        ZStack {
          Circle()
            .fill(.white)
            .frame(width: 34, height: 34)
          resizableImage(imageName: teamLogo)
            .frame(width: 30, height: 30)
        }
        if let name = teamName {
          Text(name)
            .font(.caption)
            .foregroundStyle(.white.opacity(0.75))
        }
      }
      if let score = teamScore {
        Text(score)
          .font(.title)
          .fontWeight(.bold)
          .foregroundStyle(.white)
      }
    }
  }

  private func dynamicIslandExpandedTeamTrailing(
    teamLogo: String,
    teamName: String?,
    teamScore: String?
  ) -> some View {
    VStack(spacing: 8) {
      VStack(spacing: 4) {
        ZStack {
          Circle()
            .fill(.white)
            .frame(width: 34, height: 34)
          resizableImage(imageName: teamLogo)
            .frame(width: 30, height: 30)
        }
        if let name = teamName {
          Text(name)
            .font(.caption)
            .foregroundStyle(.white.opacity(0.75))
        }
      }
      if let score = teamScore {
        Text(score)
          .font(.title)
          .fontWeight(.bold)
          .foregroundStyle(.white)
      }
    }
  }
}
