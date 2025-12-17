import ActivityKit
import SwiftUI
import WidgetKit

public struct LiveActivityAttributes: ActivityAttributes {
  public struct ContentState: Codable, Hashable {
    var caption: String
    var title: String
    var subtitle: String
    var teamLogoLeft: String
    var teamLogoRight: String
    var teamScoreLeft: Int
    var teamScoreRight: Int
    var teamNameLeft: String
    var teamNameRight: String

    public init(
      caption: String,
      title: String,
      subtitle: String,
      teamLogoLeft: String,
      teamLogoRight: String,
      teamScoreLeft: Int,
      teamScoreRight: Int,
      teamNameLeft: String,
      teamNameRight: String
    ) {
      self.caption = caption
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
    let config = ActivityConfiguration(for: LiveActivityAttributes.self) { context in
      LiveActivityView(contentState: context.state, attributes: context.attributes)
        .activityBackgroundTint(
          context.attributes.backgroundColor.map { Color(hex: $0) }
        )
        .activitySystemActionForegroundColor(Color.black)
        .applyWidgetURL(from: context.attributes.deepLinkUrl)
    } dynamicIsland: { context in
      DynamicIsland {
        DynamicIslandExpandedRegion(.leading, priority: 1) {
          dynamicIslandExpandedTeamLeading(
            teamLogo: context.state.teamLogoLeft,
            teamName: context.state.teamNameLeft,
            teamScore: context.state.teamScoreLeft
          )
          .dynamicIsland(verticalPlacement: .belowIfTooWide)
          .padding(.leading, 5)
          .applyWidgetURL(from: context.attributes.deepLinkUrl)
        }
        DynamicIslandExpandedRegion(.center) {
          VStack(spacing: 2) {
            Text(context.state.title)
              .font(.headline)
              .foregroundStyle(.white)
              .fontWeight(.semibold)
            Text(context.state.subtitle)
              .font(.caption)
              .foregroundStyle(.white.opacity(0.75))
          }
          .padding(.horizontal, 5)
          .applyWidgetURL(from: context.attributes.deepLinkUrl)
        }
        DynamicIslandExpandedRegion(.trailing) {
          dynamicIslandExpandedTeamTrailing(
            teamLogo: context.state.teamLogoRight,
            teamName: context.state.teamNameRight,
            teamScore: context.state.teamScoreRight
          )
          .padding(.trailing, 5)
          .applyWidgetURL(from: context.attributes.deepLinkUrl)
        }
      } compactLeading: {
        HStack(spacing: 4) {
          ZStack {
            Circle()
              .fill(.white)
              .frame(width: 26, height: 26)
            resizableImage(imageName: context.state.teamLogoLeft)
              .frame(width: 23, height: 23)
              .clipShape(Circle())
          }
          Text(context.state.teamScoreLeft, format: .number)
            .font(.system(size: 28).weight(.bold).width(.compressed))
            .foregroundStyle(.white)
        }
        .applyWidgetURL(from: context.attributes.deepLinkUrl)
      } compactTrailing: {
        HStack(spacing: 4) {
          Text(context.state.teamScoreRight, format: .number)
            .font(.system(size: 28).weight(.bold).width(.compressed))
            .foregroundStyle(.white)
          ZStack {
            Circle()
              .fill(.white)
              .frame(width: 26, height: 26)
            resizableImage(imageName: context.state.teamLogoRight)
              .frame(width: 23, height: 23)
              .clipShape(Circle())
          }
        }
        .applyWidgetURL(from: context.attributes.deepLinkUrl)
      } minimal: {
        HStack(spacing: -12) {
          ZStack {
            Circle()
              .fill(.white)
              .frame(width: 26, height: 26)
            resizableImage(imageName: context.state.teamLogoLeft)
              .frame(width: 23, height: 23)
              .clipShape(Circle())
          }
          ZStack {
            Circle()
              .fill(.white)
              .frame(width: 26, height: 26)
            resizableImage(imageName: context.state.teamLogoRight)
              .frame(width: 23, height: 23)
              .clipShape(Circle())
          }
        }
        .applyWidgetURL(from: context.attributes.deepLinkUrl)
      }
    }
    
    if #available(iOS 18.0, *) {
      return config.supplementalActivityFamilies([.small, .medium])
    } else {
      return config
    }
  }

  public init() {}

  private func dynamicIslandExpandedTeamLeading(
    teamLogo: String,
    teamName: String,
    teamScore: Int
  ) -> some View {
    HStack(alignment: .center, spacing: 8) {
      VStack(spacing: 4) {
        ZStack {
          Circle()
            .fill(.white)
            .frame(width: 34, height: 34)
          resizableImage(imageName: teamLogo)
            .frame(width: 30, height: 30)
            .clipShape(Circle())
        }
        Text(teamName)
          .font(.caption)
          .foregroundStyle(.white.opacity(0.75))
          .multilineTextAlignment(.center)
      }
      Text(teamScore, format: .number)
        .font(.largeTitle.weight(.bold).width(.compressed))
        .foregroundStyle(.white)
    }
  }

  private func dynamicIslandExpandedTeamTrailing(
    teamLogo: String,
    teamName: String,
    teamScore: Int
  ) -> some View {
    HStack(alignment: .center, spacing: 8) {
      Text(teamScore, format: .number)
        .font(.largeTitle.weight(.bold).width(.compressed))
        .foregroundStyle(.white)
      VStack(spacing: 4) {
        ZStack {
          Circle()
            .fill(.white)
            .frame(width: 34, height: 34)
          resizableImage(imageName: teamLogo)
            .frame(width: 30, height: 30)
            .clipShape(Circle())
        }
        Text(teamName)
          .font(.caption)
          .foregroundStyle(.white.opacity(0.75))
          .multilineTextAlignment(.center)
      }
    }
  }
}
