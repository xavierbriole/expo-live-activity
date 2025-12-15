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

      HStack(alignment: .center, spacing: 8) {
        // Left team logo and name
        if let leftLogo = contentState.teamLogoLeft {
          VStack(spacing: 4) {
            Image.dynamic(assetNameOrPath: leftLogo)
              .resizable()
              .scaledToFit()
              .frame(width: 40, height: 40)
            if let leftName = contentState.teamNameLeft {
              Text(leftName)
                .font(.caption)
                .modifier(ConditionalForegroundViewModifier(color: attributes.subtitleColor))
            }
          }
        }
        
        // Left team score
        if let leftScore = contentState.teamScoreLeft {
          Text(leftScore)
            .font(.title)
            .fontWeight(.bold)
            .modifier(ConditionalForegroundViewModifier(color: attributes.titleColor))
        }
        
        Spacer()
        
        // Centered title and subtitle
        VStack(alignment: .center, spacing: 2) {
          Text(contentState.title)
            .font(.headline)
            .fontWeight(.semibold)
            .modifier(ConditionalForegroundViewModifier(color: attributes.titleColor))
            .multilineTextAlignment(.center)
          
          if let subtitle = contentState.subtitle {
            Text(subtitle)
              .font(.subheadline)
              .modifier(ConditionalForegroundViewModifier(color: attributes.subtitleColor))
              .multilineTextAlignment(.center)
          }
        }
        
        Spacer()
        
        // Right team score
        if let rightScore = contentState.teamScoreRight {
          Text(rightScore)
            .font(.title)
            .fontWeight(.bold)
            .modifier(ConditionalForegroundViewModifier(color: attributes.titleColor))
        }
        
        // Right team logo and name
        if let rightLogo = contentState.teamLogoRight {
          VStack(spacing: 4) {
            Image.dynamic(assetNameOrPath: rightLogo)
              .resizable()
              .scaledToFit()
              .frame(width: 40, height: 40)
            if let rightName = contentState.teamNameRight {
              Text(rightName)
                .font(.caption)
                .modifier(ConditionalForegroundViewModifier(color: attributes.subtitleColor))
            }
          }
        }
      }
      .padding(padding)
    }
  }

#endif
