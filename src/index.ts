import { EventSubscription } from 'expo-modules-core'
import { Platform } from 'react-native'

import ExpoLiveActivityModule from './ExpoLiveActivityModule'

type Voidable<T> = T | void

export type LiveActivityState = {
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

export type NativeLiveActivityState = {
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

export type LiveActivityConfig = {
  gradientStartColor?: string
  gradientEndColor?: string
  titleColor?: string
  subtitleColor?: string
  deepLinkUrl?: string
}

export type ActivityTokenReceivedEvent = {
  activityID: string
  activityName: string
  activityPushToken: string
}

export type ActivityPushToStartTokenReceivedEvent = {
  activityPushToStartToken: string | null
}

type ActivityState = 'active' | 'dismissed' | 'pending' | 'stale' | 'ended'

export type ActivityUpdateEvent = {
  activityID: string
  activityName: string
  activityState: ActivityState
}

export type LiveActivityModuleEvents = {
  onTokenReceived: (params: ActivityTokenReceivedEvent) => void
  onPushToStartTokenReceived: (params: ActivityPushToStartTokenReceivedEvent) => void
  onStateChange: (params: ActivityUpdateEvent) => void
}

function assertIOS(name: string) {
  const isIOS = Platform.OS === 'ios'

  if (!isIOS) console.error(`${name} is only available on iOS`)

  return isIOS
}

/**
 * @param {LiveActivityState} state The state for the live activity.
 * @param {LiveActivityConfig} config Live activity config object.
 * @param {number} relevanceScore A score you assign that determines the order in which your Live Activities appear when you start several Live Activities for your app. The relevance score is a number between 0.0 and 1.0, with 1.0 being the highest possible score.
 * @returns {string} The identifier of the started activity or undefined if creating live activity failed.
 */
export function startActivity(
  state: LiveActivityState,
  config?: LiveActivityConfig,
  relevanceScore?: number
): Voidable<string> {
  if (assertIOS('startActivity')) return ExpoLiveActivityModule.startActivity(state, config, relevanceScore)
}

/**
 * @param {string} id The identifier of the activity to stop.
 * @param {LiveActivityState} state The updated state for the live activity.
 * @param {number} relevanceScore A score you assign that determines the order in which your Live Activities appear when you start several Live Activities for your app. The relevance score is a number between 0.0 and 1.0, with 1.0 being the highest possible score.
 */
export function stopActivity(id: string, state: LiveActivityState, relevanceScore?: number) {
  if (assertIOS('stopActivity')) return ExpoLiveActivityModule.stopActivity(id, state, relevanceScore)
}

/**
 * @param {string} id The identifier of the activity to update.
 * @param {LiveActivityState} state The updated state for the live activity.
 * @param {number} relevanceScore A score you assign that determines the order in which your Live Activities appear when you start several Live Activities for your app. The relevance score is a number between 0.0 and 1.0, with 1.0 being the highest possible score.
 */
export function updateActivity(id: string, state: LiveActivityState, relevanceScore?: number) {
  if (assertIOS('updateActivity')) return ExpoLiveActivityModule.updateActivity(id, state, relevanceScore)
}

/**
 * @param {function} updateTokenListener The listener function that will be called when an update token is received.
 */
export function addActivityTokenListener(
  updateTokenListener: (event: ActivityTokenReceivedEvent) => void
): Voidable<EventSubscription> {
  if (assertIOS('addActivityTokenListener'))
    return ExpoLiveActivityModule.addListener('onTokenReceived', updateTokenListener)
}

/**
 * Adds a listener that is called when a push-to-start token is received. Supported only on iOS > 17.2.
 * On earlier iOS versions, the listener will return null as a token.
 * @param {function} listener The listener function that will be called when the observer starts and then when a push-to-start token is received.
 */
export function addActivityPushToStartTokenListener(
  listener: (event: ActivityPushToStartTokenReceivedEvent) => void
): Voidable<EventSubscription> {
  if (assertIOS('addActivityPushToStartTokenListener'))
    return ExpoLiveActivityModule.addListener('onPushToStartTokenReceived', listener)
}

/**
 * @param {function} statusListener The listener function that will be called when an activity status changes.
 */
export function addActivityUpdatesListener(
  statusListener: (event: ActivityUpdateEvent) => void
): Voidable<EventSubscription> {
  if (assertIOS('addActivityUpdatesListener'))
    return ExpoLiveActivityModule.addListener('onStateChange', statusListener)
}
