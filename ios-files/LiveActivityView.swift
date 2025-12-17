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
      if #available(iOS 18.0, *) {
        ViewThatFits {
          PhoneLayoutView(contentState: contentState, attributes: attributes)
          WatchLayoutView(contentState: contentState, attributes: attributes)
        }
      } else {
        PhoneLayoutView(contentState: contentState, attributes: attributes)
      }
    }
  }
  
  struct PhoneLayoutView: View {
    let contentState: LiveActivityAttributes.ContentState
    let attributes: LiveActivityAttributes
    
    var body: some View {
      VStack(spacing: 8) {
        Text(contentState.caption)
          .font(.caption)
          .modifier(ConditionalForegroundViewModifier(color: attributes.subtitleColor))
          .lineLimit(1)
        
        HStack(alignment: .center, spacing: 8) {
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
          
          Text(contentState.teamScoreLeft, format: .number)
            .font(.largeTitle.weight(.bold).width(.compressed))
            .modifier(ConditionalForegroundViewModifier(color: attributes.titleColor))
          
          Spacer()
          
          VStack(alignment: .center, spacing: 2) {
            Text(contentState.title)
              .font(.headline)
              .fontWeight(.semibold)
              .modifier(ConditionalForegroundViewModifier(color: attributes.titleColor))
              .multilineTextAlignment(.center)
              .lineLimit(1)
            
            Text(contentState.subtitle)
              .font(.subheadline)
              .modifier(ConditionalForegroundViewModifier(color: attributes.subtitleColor))
              .multilineTextAlignment(.center)
              .lineLimit(2)
          }
          .frame(maxWidth: 150)
          
          Spacer()
          
          Text(contentState.teamScoreRight, format: .number)
            .font(.largeTitle.weight(.bold).width(.compressed))
            .modifier(ConditionalForegroundViewModifier(color: attributes.titleColor))
          
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
      .padding(16)
    }
  }
  
  struct WatchLayoutView: View {
    let contentState: LiveActivityAttributes.ContentState
    let attributes: LiveActivityAttributes
    
    var body: some View {
      VStack(spacing: 4) {
        Text(contentState.caption)
          .font(.caption)
          .modifier(ConditionalForegroundViewModifier(color: attributes.subtitleColor))
        
        HStack(alignment: .center, spacing: 8) {
          VStack(spacing: 2) {
            Text(contentState.teamScoreLeft, format: .number)
              .font(.title2.weight(.bold).width(.compressed))
              .modifier(ConditionalForegroundViewModifier(color: attributes.titleColor))
            Text(contentState.teamNameLeft)
              .font(.caption2)
              .modifier(ConditionalForegroundViewModifier(color: attributes.subtitleColor))
              .lineLimit(1)
          }
          
          Spacer()
          

          VStack(alignment: .center, spacing: 2) {
            Text(contentState.title)
              .font(.caption2)
              .fontWeight(.semibold)
              .modifier(ConditionalForegroundViewModifier(color: attributes.titleColor))
              .multilineTextAlignment(.center)
            
            Text(contentState.subtitle)
              .font(.caption)
              .modifier(ConditionalForegroundViewModifier(color: attributes.subtitleColor))
              .multilineTextAlignment(.center)
              .lineLimit(2)
          }
          
          Spacer()
          
          VStack(spacing: 2) {
            Text(contentState.teamScoreRight, format: .number)
              .font(.title2.weight(.bold).width(.compressed))
              .modifier(ConditionalForegroundViewModifier(color: attributes.titleColor))
            Text(contentState.teamNameRight)
              .font(.caption2)
              .modifier(ConditionalForegroundViewModifier(color: attributes.subtitleColor))
              .lineLimit(1)
          }
        }
      }
      .padding(8)
    }
  }

#endif
