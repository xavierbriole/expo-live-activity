import { EventSubscription } from 'expo-modules-core'
import { Platform } from 'react-native'

import ExpoLiveActivityModule from './ExpoLiveActivityModule'

type Voidable<T> = T | void

export type LiveActivityState = {
  title: string
  subtitle?: string
  teamLogoLeft?: string
  teamLogoRight?: string
  teamScoreLeft?: string
  teamScoreRight?: string
  teamNameLeft?: string
  teamNameRight?: string
}

export type NativeLiveActivityState = {
  title: string
  subtitle?: string
  teamLogoLeft?: string
  teamLogoRight?: string
  teamScoreLeft?: string
  teamScoreRight?: string
  teamNameLeft?: string
  teamNameRight?: string
}

export type LiveActivityConfig = {
  backgroundColor?: string
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
 * @returns {string} The identifier of the started activity or undefined if creating live activity failed.
 */
export function startActivity(state: LiveActivityState, config?: LiveActivityConfig): Voidable<string> {
  if (assertIOS('startActivity')) return ExpoLiveActivityModule.startActivity(state, config)
}

/**
 * @param {string} id The identifier of the activity to stop.
 * @param {LiveActivityState} state The updated state for the live activity.
 */
export function stopActivity(id: string, state: LiveActivityState) {
  if (assertIOS('stopActivity')) return ExpoLiveActivityModule.stopActivity(id, state)
}

/**
 * @param {string} id The identifier of the activity to update.
 * @param {LiveActivityState} state The updated state for the live activity.
 */
export function updateActivity(id: string, state: LiveActivityState) {
  if (assertIOS('updateActivity')) return ExpoLiveActivityModule.updateActivity(id, state)
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
 * @param {function} pushPushToStartTokenListener The listener function that will be called when the observer starts and then when a push-to-start token is received.
 */
export function addActivityPushToStartTokenListener(
  pushPushToStartTokenListener: (event: ActivityPushToStartTokenReceivedEvent) => void
): Voidable<EventSubscription> {
  if (assertIOS('addActivityPushToStartTokenListener'))
    return ExpoLiveActivityModule.addListener('onPushToStartTokenReceived', pushPushToStartTokenListener)
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
