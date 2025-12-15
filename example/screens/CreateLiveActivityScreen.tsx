import type { LiveActivityConfig, LiveActivityState } from 'expo-live-activity'
import * as LiveActivity from 'expo-live-activity'
import { useState } from 'react'
import {
  Button,
  Keyboard,
  ScrollView,
  StyleSheet,
  Text,
  TextInput,
  View,
} from 'react-native'

export default function CreateLiveActivityScreen() {
  const [activityId, setActivityID] = useState<string | null>()
  const [title, setTitle] = useState('LEC Week 1')
  const [subtitle, setSubtitle] = useState('Best of 3')
  const [teamLogoLeft, setTeamLogoLeft] = useState('team-left')
  const [teamLogoRight, setTeamLogoRight] = useState('team-right')
  const [teamScoreLeft, setTeamScoreLeft] = useState('0')
  const [teamScoreRight, setTeamScoreRight] = useState('0')
  const [teamNameLeft, setTeamNameLeft] = useState('Team Left')
  const [teamNameRight, setTeamNameRight] = useState('Team Right')

  const activityIdState = activityId ? `Activity ID: ${activityId}` : 'No active activity'
  console.log(activityIdState)

  const startActivity = () => {
    Keyboard.dismiss()
    const state: LiveActivityState = {
      title,
      subtitle,
      teamLogoLeft,
      teamLogoRight,
      teamScoreLeft,
      teamScoreRight,
      teamNameLeft,
      teamNameRight,
    }

    try {
      const id = LiveActivity.startActivity(state, baseActivityConfig)
      if (id) setActivityID(id)
    } catch (e) {
      console.error('Starting activity failed! ' + e)
    }
  }

  const stopActivity = () => {
    const state: LiveActivityState = {
      title,
      subtitle,
      teamLogoLeft,
      teamLogoRight,
      teamScoreLeft,
      teamScoreRight,
      teamNameLeft,
      teamNameRight,
    }
    try {
      activityId && LiveActivity.stopActivity(activityId, state)
      setActivityID(null)
    } catch (e) {
      console.error('Stopping activity failed! ' + e)
    }
  }

  const updateActivity = () => {
    const state: LiveActivityState = {
      title,
      subtitle,
      teamLogoLeft,
      teamLogoRight,
      teamScoreLeft,
      teamScoreRight,
      teamNameLeft,
      teamNameRight,
    }
    try {
      activityId && LiveActivity.updateActivity(activityId, state)
    } catch (e) {
      console.error('Updating activity failed! ' + e)
    }
  }

  return (
    <ScrollView style={styles.scroll}>
      <View style={styles.container}>
        <Text style={styles.header}>League of Legends Live Activity</Text>

        <Text style={styles.label}>Match Title:</Text>
        <TextInput
          style={styles.input}
          onChangeText={setTitle}
          placeholder="e.g., LEC Week 1"
          value={title}
          testID="input-title"
        />

        <Text style={styles.label}>Match Subtitle:</Text>
        <TextInput
          style={styles.input}
          onChangeText={setSubtitle}
          placeholder="e.g., Best of 3"
          value={subtitle}
          testID="input-subtitle"
        />

        <View style={styles.section}>
          <Text style={styles.sectionTitle}>Left Team</Text>
          
          <Text style={styles.label}>Team Logo (asset name):</Text>
          <TextInput
            style={styles.input}
            onChangeText={setTeamLogoLeft}
            placeholder="e.g., fnatic-logo"
            value={teamLogoLeft}
            autoCapitalize="none"
          />

          <Text style={styles.label}>Team Name:</Text>
          <TextInput
            style={styles.input}
            onChangeText={setTeamNameLeft}
            placeholder="e.g., Fnatic"
            value={teamNameLeft}
          />

          <Text style={styles.label}>Score:</Text>
          <TextInput
            style={styles.input}
            onChangeText={setTeamScoreLeft}
            placeholder="0"
            value={teamScoreLeft}
            keyboardType="number-pad"
          />
        </View>

        <View style={styles.section}>
          <Text style={styles.sectionTitle}>Right Team</Text>
          
          <Text style={styles.label}>Team Logo (asset name):</Text>
          <TextInput
            style={styles.input}
            onChangeText={setTeamLogoRight}
            placeholder="e.g., g2-logo"
            value={teamLogoRight}
            autoCapitalize="none"
          />

          <Text style={styles.label}>Team Name:</Text>
          <TextInput
            style={styles.input}
            onChangeText={setTeamNameRight}
            placeholder="e.g., G2 Esports"
            value={teamNameRight}
          />

          <Text style={styles.label}>Score:</Text>
          <TextInput
            style={styles.input}
            onChangeText={setTeamScoreRight}
            placeholder="0"
            value={teamScoreRight}
            keyboardType="number-pad"
          />
        </View>

        <View style={styles.buttonsContainer}>
          <Button
            title="Start Activity"
            onPress={startActivity}
            disabled={title === '' || !!activityId}
            testID="btn-start-activity"
          />
          <Button title="Stop Activity" onPress={stopActivity} disabled={!activityId} />
          <Button title="Update Activity" onPress={updateActivity} disabled={!activityId} />
        </View>

        <Text style={styles.statusText}>{activityIdState}</Text>
      </View>
    </ScrollView>
  )
}

const baseActivityConfig: LiveActivityConfig = {
  backgroundColor: '001A72',
  titleColor: 'EBEBF0',
  subtitleColor: '#FFFFFF75',
  deepLinkUrl: '/dashboard',
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    paddingVertical: 20,
  },
  scroll: {
    flex: 1,
  },
  header: {
    fontSize: 24,
    fontWeight: 'bold',
    marginBottom: 20,
    width: '90%',
  },
  section: {
    width: '90%',
    marginVertical: 10,
    padding: 15,
    backgroundColor: '#f5f5f5',
    borderRadius: 10,
  },
  sectionTitle: {
    fontSize: 18,
    fontWeight: 'bold',
    marginBottom: 10,
  },
  buttonsContainer: {
    padding: 30,
    width: '90%',
  },
  label: {
    width: '100%',
    fontSize: 15,
    marginTop: 10,
    marginBottom: 5,
    fontWeight: '500',
  },
  input: {
    height: 45,
    width: '100%',
    borderWidth: 1,
    borderColor: 'gray',
    borderRadius: 10,
    padding: 10,
  },
  statusText: {
    fontSize: 14,
    color: '#666',
    marginTop: 10,
  },
})
