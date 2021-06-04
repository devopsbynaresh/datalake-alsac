# CloudWatch Alarm

Used to create alarms for all of the pertinent data lake metrics.

If an error is detected in a specified threshold, the alarm will go into the ALARM state and publish to an SNS topic, which will send out e-mail notifications to subscribers.
