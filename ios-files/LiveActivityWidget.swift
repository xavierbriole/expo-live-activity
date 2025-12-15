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
    var teamScoreLeft: String
    var teamScoreRight: String
    var teamNameLeft: String
    var teamNameRight: String

    public init(
      caption: String,
      title: String,
      subtitle: String,
      teamLogoLeft: String,
      teamLogoRight: String,
      teamScoreLeft: String,
      teamScoreRight: String,
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
          }
          Text(context.state.teamScoreLeft)
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundStyle(.white)
        }
        .applyWidgetURL(from: context.attributes.deepLinkUrl)
      } compactTrailing: {
        HStack(spacing: 4) {
          Text(context.state.teamScoreRight)
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundStyle(.white)
          ZStack {
            Circle()
              .fill(.white)
              .frame(width: 26, height: 26)
            resizableImage(imageName: context.state.teamLogoRight)
              .frame(width: 23, height: 23)
          }
        }
        .applyWidgetURL(from: context.attributes.deepLinkUrl)
      } minimal: {
        VStack(spacing: 2) {
          ZStack {
            Circle()
              .fill(.white)
              .frame(width: 18, height: 18)
            resizableImage(imageName: context.state.teamLogoLeft)
              .frame(width: 16, height: 16)
          }
          ZStack {
            Circle()
              .fill(.white)
              .frame(width: 18, height: 18)
            resizableImage(imageName: context.state.teamLogoRight)
              .frame(width: 16, height: 16)
          }
        }
        .applyWidgetURL(from: context.attributes.deepLinkUrl)
      }
    }
  }

  public init() {}

  private func dynamicIslandExpandedTeamLeading(
    teamLogo: String,
    teamName: String,
    teamScore: String
  ) -> some View {
    HStack(alignment: .center, spacing: 8) {
      VStack(spacing: 4) {
        ZStack {
          Circle()
            .fill(.white)
            .frame(width: 34, height: 34)
          resizableImage(imageName: teamLogo)
            .frame(width: 30, height: 30)
        }
        Text(teamName)
          .font(.caption)
          .foregroundStyle(.white.opacity(0.75))
          .multilineTextAlignment(.center)
      }
      Text(teamScore)
        .font(.title)
        .fontWeight(.bold)
        .foregroundStyle(.white)
    }
  }

  private func dynamicIslandExpandedTeamTrailing(
    teamLogo: String,
    teamName: String,
    teamScore: String
  ) -> some View {
    HStack(alignment: .center, spacing: 8) {
      Text(teamScore)
        .font(.title)
        .fontWeight(.bold)
        .foregroundStyle(.white)
      VStack(spacing: 4) {
        ZStack {
          Circle()
            .fill(.white)
            .frame(width: 34, height: 34)
          resizableImage(imageName: teamLogo)
            .frame(width: 30, height: 30)
        }
        Text(teamName)
          .font(.caption)
          .foregroundStyle(.white.opacity(0.75))
          .multilineTextAlignment(.center)
      }
    }
  }
}
