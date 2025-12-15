import SwiftUI
import WidgetKit

#if canImport(ActivityKit)

  struct ConditionalForegroundViewModifier: ViewModifier {
    let color: String?

    func body(content: Content) -> some View {
      if let color = color {
        content.foregroundStyle(Color(hex: color))
      } else {
        content
      }
    }
  }

  struct DebugLog: View {
    #if DEBUG
      private let message: String
      init(_ message: String) {
        self.message = message
        print(message)
      }

      var body: some View {
        Text(message)
          .font(.caption2)
          .foregroundStyle(.red)
      }
    #else
      init(_: String) {}
      var body: some View { EmptyView() }
    #endif
  }

  struct LiveActivityView: View {
    let contentState: LiveActivityAttributes.ContentState
    let attributes: LiveActivityAttributes

    var body: some View {
      let defaultPadding = 16
      let padding = CGFloat(defaultPadding)

      VStack(spacing: 8) {
        // Match type label at the top (e.g., "Best of 5")
        Text(contentState.matchType)
          .font(.caption)
          .modifier(ConditionalForegroundViewModifier(color: attributes.subtitleColor))
        
        HStack(alignment: .center, spacing: 8) {
        // Left team logo and name
        VStack(spacing: 4) {
          Image.dynamic(assetNameOrPath: contentState.teamLogoLeft)
            .resizable()
            .scaledToFit()
            .frame(width: 40, height: 40)
          Text(contentState.teamNameLeft)
            .font(.caption)
            .modifier(ConditionalForegroundViewModifier(color: attributes.subtitleColor))
            .multilineTextAlignment(.center)
        }
        
        // Left team score
        Text(contentState.teamScoreLeft)
          .font(.title)
          .fontWeight(.bold)
          .modifier(ConditionalForegroundViewModifier(color: attributes.titleColor))
        
        Spacer()
        
        // Centered title and subtitle
        VStack(alignment: .center, spacing: 2) {
          Text(contentState.title)
            .font(.headline)
            .fontWeight(.semibold)
            .modifier(ConditionalForegroundViewModifier(color: attributes.titleColor))
            .multilineTextAlignment(.center)
          
          Text(contentState.subtitle)
            .font(.subheadline)
            .modifier(ConditionalForegroundViewModifier(color: attributes.subtitleColor))
            .multilineTextAlignment(.center)
        }
        
        Spacer()
        
        // Right team score
        Text(contentState.teamScoreRight)
          .font(.title)
          .fontWeight(.bold)
          .modifier(ConditionalForegroundViewModifier(color: attributes.titleColor))
        
        // Right team logo and name
        VStack(spacing: 4) {
          Image.dynamic(assetNameOrPath: contentState.teamLogoRight)
            .resizable()
            .scaledToFit()
            .frame(width: 40, height: 40)
          Text(contentState.teamNameRight)
            .font(.caption)
            .modifier(ConditionalForegroundViewModifier(color: attributes.subtitleColor))
            .multilineTextAlignment(.center)
        }
        }
      }
      .padding(padding)
    }
  }

#endif
