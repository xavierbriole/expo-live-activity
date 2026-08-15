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

- **`startActivity(state: LiveActivityState, config?: LiveActivityConfig, relevanceScore?: number): string | undefined`**:
  Start a new Live Activity. Takes a `state` configuration object for initial activity state and an optional `config` object to customize appearance or behavior. It returns the `ID` of the created Live Activity, which should be stored for future reference. If the Live Activity can't be created (eg. on android or iOS lower than 16.2), it will return `undefined`. The `relevanceScore` is score you assign that determines the order in which your Live Activities appear when you start several Live Activities for your app. The relevance score is a number between 0.0 and 1.0, with 1.0 being the highest possible score.

- **`updateActivity(id: string, state: LiveActivityState, relevanceScore?: number)`**:
  Update an existing Live Activity. The `state` object should contain updated information. The `id` indicates which activity should be updated. The `relevanceScore` is score you assign that determines the order in which your Live Activities appear when you start several Live Activities for your app. The relevance score is a number between 0.0 and 1.0, with 1.0 being the highest possible score.

- **`stopActivity(id: string, state: LiveActivityState, relevanceScore?: number)`**:
  Terminate an ongoing Live Activity. The `state` object should contain the final state of the activity. The `id` indicates which activity should be stopped. The `relevanceScore` is score you assign that determines the order in which your Live Activities appear when you start several Live Activities for your app. The relevance score is a number between 0.0 and 1.0, with 1.0 being the highest possible score.

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
  shortCaption: string
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
   gradientStartColor?: string;
   gradientEndColor?: string;
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
  caption: 'Nexus League Summer 2026 • Regular Season',
  shortCaption: 'Nexus League',
  title: 'BO5',
  subtitle: 'Game 1 in progress',
  teamLogoLeft: 't1', // name of the image in assets/liveActivity folder
  teamLogoRight: 'karmine-corp', // name of the image in assets/liveActivity folder
  teamScoreLeft: 2,
  teamScoreRight: 3,
  teamNameLeft: 'T1',
  teamNameRight: 'KC',
}

const config: LiveActivity.LiveActivityConfig = {
  gradientStartColor: '#3D5A96',
  gradientEndColor: '#8E4560',
  titleColor: '#EBEBF0',
  subtitleColor: '#FFFFFF75',
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
      "caption": "Nexus League Summer 2026 • Regular Season",
      "shortCaption": "Nexus League",
      "title": "BO5",
      "subtitle": "Game 1 in progress",
      "teamLogoLeft": "t1",
      "teamLogoRight": "karmine-corp",
      "teamScoreLeft": 2,
      "teamScoreRight": 3,
      "teamNameLeft": "T1",
      "teamNameRight": "KC"
    },
    "timestamp": 1754491435000, // timestamp of when the push notification was sent
    "attributes-type": "LiveActivityAttributes",
    "attributes": {
      "name": "1839783", // matchId
      "gradientStartColor": "3D5A96",
      "gradientEndColor": "8E4560",
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
      "caption": "Nexus League Summer 2026 • Regular Season",
      "shortCaption": "Nexus League",
      "title": "BO5",
      "subtitle": "T1 won game 1 in 17:32",
      "teamLogoLeft": "t1",
      "teamLogoRight": "karmine-corp",
      "teamScoreLeft": 2,
      "teamScoreRight": 3,
      "teamNameLeft": "T1",
      "teamNameRight": "KC"
    },
    "timestamp": 1754063621319 // timestamp of when the push notification was sent
  }
}
```

## Contributing

### Running the example app locally

The `example/` folder contains a standalone Expo app used to develop and test the module. Since this module isn't supported in Expo Go, you need to build a custom dev client.

1. **Install dependencies at the repo root and in the example app:**

   ```sh
   npm install
   cd example
   npm install
   ```

2. **Generate the native iOS project and build the dev client:**

   ```sh
   npx expo prebuild --clean
   npx expo run:ios
   ```

   This compiles the app with the `expo-live-activity` native module included and installs/launches it on an iOS simulator.

3. **For subsequent runs**, once the dev client is built, you can just start the Metro bundler:

   ```sh
   npx expo start
   ```

> [!WARNING]
> Always run these commands from inside the `example/` folder. Running `expo prebuild`/`expo run:ios` from the repo root will overwrite the module's native source files in `ios/`.

If you change the module's native (`ios/`) or plugin (`plugin/`) source, re-run `npx expo prebuild --clean` in `example/` to pick up the changes.

### Publishing a new version

The [scripts/publish.sh](scripts/publish.sh) script automates version bumping, tagging and publishing to GitHub Packages:

```sh
./scripts/publish.sh [patch|minor|major]
```

By default it bumps the `patch` version. Running it will:

1. Check that the repository has no uncommitted changes (aborts otherwise).
2. Warn if you're not on `main`/`master`, asking for confirmation to continue.
3. Bump the version in `package.json` with `npm version` (without creating a git tag).
4. Commit the version bump (`chore: bump version to X.Y.Z`).
5. Create a `vX.Y.Z` git tag.
6. Push the current branch and the new tag to `origin`.
7. Publish the package to GitHub Packages with `npm publish`.

> [!NOTE]
> `npm publish` relies on your local npm configuration being authenticated against GitHub Packages.

### Syncing with Upstream

This repository is a fork of [software-mansion-labs/expo-live-activity](https://github.com/software-mansion-labs/expo-live-activity). To sync with upstream updates:

1. **Fetch the latest changes from upstream:**

   ```bash
   gitup
   ```

2. **Merge upstream with selective file choice:**

   ```bash
   git merge upstream/main --no-commit --no-ff
   ```

3. **To keep your version of a conflicting file:**

   ```bash
   git checkout --ours <file>
   ```

4. **To keep the upstream version of a file:**

   ```bash
   git checkout --theirs <file>
   ```

5. **Add resolved files and finalize the merge:**
   ```bash
   git add .
   git commit --no-edit
   git push origin main
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
