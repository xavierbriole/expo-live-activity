![expo-live-activity by Software Mansion](https://github.com/user-attachments/assets/9f9be263-84ee-4034-a3ca-39c72c189544)

> [!WARNING]  
> This library is in early development stage; breaking changes can be introduced in minor version upgrades.

# expo-live-activity

`expo-live-activity` is a React Native module designed for use with Expo to manage and display Live Activities on iOS devices exclusively. This module leverages the Live Activities feature introduced in iOS 16, allowing developers to deliver timely updates right on the lock screen.

## Features

- Start, update, and stop Live Activities directly from your React Native application.
- Easy integration with a comprehensive API.
- Custom image support within Live Activities with a pre-configured path.
- Listen and handle changes in push notification tokens associated with a Live Activity.

## Platform compatibility

**Note:** This module is intended for use on **iOS devices only**. The minimal iOS version that supports Live Activities is 16.2. When methods are invoked on platforms other than iOS or on older iOS versions, they will log an error, ensuring that they are used in the correct context.

## Installation

> [!NOTE]  
> The library isn't supported in Expo Go; to set it up correctly you need to use [Expo DevClient](https://docs.expo.dev/versions/latest/sdk/dev-client/) .
> To begin using `expo-live-activity`, follow the installation and configuration steps outlined below:

### Step 1: Installation

Run the following command to add the expo-live-activity module to your project:

```sh
npx expo install @xavierbriole/expo-live-activity
```

### Step 2: Config Plugin Setup

The module comes with a built-in config plugin that creates a target in iOS with all the necessary files. The images used in Live Activities should be added to a pre-defined folder in your assets directory:

1. **Add the config plugin to your app.json or app.config.js:**
   ```json
   {
     "expo": {
       "plugins": ["@xavierbriole/expo-live-activity"]
     }
   }
   ```
   If you want to update Live Activity with push notifications you can add option `"enablePushNotifications": true`:
   ```json
   {
     "expo": {
       "plugins": [
         [
           "@xavierbriole/expo-live-activity",
           {
             "enablePushNotifications": true
           }
         ]
       ]
     }
   }
   ```
2. **Assets configuration:**
   Place images intended for Live Activities in the `assets/liveActivity` folder. The plugin manages these assets automatically.

   Then prebuild your app with:

   ```sh
   npx expo prebuild --clean
   ```

> [!NOTE]
> Because of iOS limitations, the assets can't be bigger than 4KB ([native Live Activity documentation](https://developer.apple.com/documentation/activitykit/displaying-live-data-with-live-activities#Understand-constraints))

### Step 3: Usage in Your React Native App

Import the functionalities provided by the `expo-live-activity` module in your JavaScript or TypeScript files:

```javascript
import * as LiveActivity from '@xavierbriole/expo-live-activity'
```

## API

`expo-live-activity` module exports three primary functions to manage Live Activities:

### Managing Live Activities

- **`startActivity(state: LiveActivityState, config?: LiveActivityConfig): string | undefined`**:
  Start a new Live Activity. Takes a `state` configuration object for initial activity state and an optional `config` object to customize appearance or behavior. It returns the `ID` of the created Live Activity, which should be stored for future reference. If the Live Activity can't be created (eg. on android or iOS lower than 16.2), it will return `undefined`.

- **`updateActivity(id: string, state: LiveActivityState)`**:
  Update an existing Live Activity. The `state` object should contain updated information. The `activityId` indicates which activity should be updated.

- **`stopActivity(id: string, state: LiveActivityState)`**:
  Terminate an ongoing Live Activity. The `state` object should contain the final state of the activity. The `activityId` indicates which activity should be stopped.

### Handling Push Notification Tokens

- **`addActivityPushToStartTokenListener(listener: (event: ActivityPushToStartTokenReceivedEvent) => void): EventSubscription | undefined`**:
  Subscribe to changes in the push to start token for starting live acitivities with push notifications.
- **`addActivityTokenListener(listener: (event: ActivityTokenReceivedEvent) => void): EventSubscription | undefined`**:
  Subscribe to changes in the push notification token associated with Live Activities.

### Deep linking

When starting a new Live Activity, it's possible to pass `deepLinkUrl` field in `config` object. This usually should be a path to one of your screens. If you are using @react-navigation in your project, it's easiest to enable auto linking:

```typescript
const prefix = Linking.createURL('')

export default function App() {
  const url = Linking.useLinkingURL()
  const linking = {
    enabled: 'auto' as const,
    prefixes: [prefix],
  }
}

// Then start the activity with:
LiveActivity.startActivity(state, {
  deepLinkUrl: '/match',
})
```

URL scheme will be taken automatically from `scheme` field in `app.json` or fall back to `ios.bundleIdentifier`.

### State Object Structure

The `state` object should include:

```typescript
{
  caption: string
  title: string
  subtitle: string
  teamLogoLeft: string
  teamLogoRight: string
  teamScoreLeft: number
  teamScoreRight: number
  teamNameLeft: string
  teamNameRight: string
}
```

### Config Object Structure

The `config` object should include:

```typescript
{
   backgroundColor?: string;
   titleColor?: string;
   subtitleColor?: string;
   deepLinkUrl?: string;
};
```

### Activity updates

`LiveActivity.addActivityUpdatesListener` API allows to subscribe to changes in Live Activity state. This is useful for example when you want to update the Live Activity with new information. Handler will receive an `ActivityUpdateEvent` object which contains information about new state under `activityState` property which is of `ActivityState` type, so the possible values are: `'active'`, `'dismissed'`, `'pending'`, `'stale'` or `'ended'`. Apart from this property, the event also contains `activityId` and `activityName` which can be used to identify the Live Activity.

## Example Usage

Managing a Live Activity:

```typescript
const state: LiveActivity.LiveActivityState = {
  caption: 'LEC Week 1',
  title: 'BO5',
  subtitle: 'Game 1 in progress',
  teamLogoLeft: 't1', // name of the image in assets/liveActivity folder
  teamLogoRight: 'g2', // name of the image in assets/liveActivity folder
  teamScoreLeft: 2,
  teamScoreRight: 3,
  teamNameLeft: 'T1',
  teamNameRight: 'G2',
}

const config: LiveActivity.LiveActivityConfig = {
  backgroundColor: '#FFFFFF',
  titleColor: '#000000',
  subtitleColor: '#333333',
  deepLinkUrl: '/match',
}

const activityId = LiveActivity.startActivity(state, config)
// Store activityId for future reference
```

This will initiate a Live Activity with the specified title, subtitle, image from your configured assets folder and a time to which there will be a countdown in a progress view.

Subscribing to push token changes:

```typescript
useEffect(() => {
  const updateTokenSubscription = LiveActivity.addActivityTokenListener(
    ({ activityID: newActivityID, activityName: newName, activityPushToken: newToken }) => {
      // Send token to a remote server to update Live Activity with push notifications
    }
  )
  const startTokenSubscription = LiveActivity.addActivityPushToStartTokenListener(
    ({ activityPushToStartToken: newActivityPushToStartToken }) => {
      // Send token to a remote server to start Live Activity with push notifications
    }
  )

  return () => {
    updateTokenSubscription?.remove()
    startTokenSubscription?.remove()
  }
}, [])
```

> [!NOTE]
> Receiving push token may not work on simulators. Make sure to use physical device when testing this functionality.

## Push notifications

By default, starting and updating Live Activity is possible only via API. If you want to have possibility to start or update Live Activity using push notifications, you can enable that feature by adding `"enablePushNotifications": true` in the plugin config in your `app.json` or `app.config.ts` file.

> [!NOTE]
> PushToStart works only for iOS 17.2 and higher.

Example payload for starting Live Activity:

```json
{
  "aps": {
    "event": "start",
    "content-state": {
      "caption": "LEC Week 1",
      "title": "BO5",
      "subtitle": "Game 1 in progress",
      "teamLogoLeft": "t1",
      "teamLogoRight": "g2",
      "teamScoreLeft": 2,
      "teamScoreRight": 3,
      "teamNameLeft": "T1",
      "teamNameRight": "G2"
    },
    "timestamp": 1754491435000, // timestamp of when the push notification was sent
    "attributes-type": "LiveActivityAttributes",
    "attributes": {
      "name": "1839783", // matchId
      "backgroundColor": "001A72",
      "titleColor": "EBEBF0",
      "subtitleColor": "FFFFFF75",
      "deepLinkUrl": "/match"
    },
    "alert": {
      "title": "",
      "body": "",
      "sound": "default"
    }
  }
}
```

Example payload for updating Live Activity:

```json
{
  "aps": {
    "event": "update",
    "content-state": {
      "caption": "LEC Week 1",
      "title": "BO5",
      "subtitle": "T1 won game 1 in 17:32",
      "teamLogoLeft": "t1",
      "teamLogoRight": "g2",
      "teamScoreLeft": 2,
      "teamScoreRight": 3,
      "teamNameLeft": "T1",
      "teamNameRight": "G2"
    },
    "timestamp": 1754063621319 // timestamp of when the push notification was sent
  }
}
```

## expo-live-activity is created by Software Mansion

[![swm](https://logo.swmansion.com/logo?color=white&variant=desktop&width=150&tag=typegpu-github 'Software Mansion')](https://swmansion.com)

Since 2012 [Software Mansion](https://swmansion.com) is a software agency with
experience in building web and mobile apps. We are Core React Native
Contributors and experts in dealing with all kinds of React Native issues. We
can help you build your next dream product –
[Hire us](https://swmansion.com/contact/projects?utm_source=typegpu&utm_medium=readme).

<!-- automd:contributors author="software-mansion" -->

Made by [@software-mansion](https://github.com/software-mansion) and
[community](https://github.com/software-mansion-labs/expo-live-activity/graphs/contributors) 💛
<br><br>
<a href="https://github.com/software-mansion-labs/expo-live-activity/graphs/contributors">
<img src="https://contrib.rocks/image?repo=software-mansion-labs/expo-live-activity" />
</a>

<!-- /automd -->
