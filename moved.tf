moved {
  from = module.event_notification.time_sleep.wait_for_authorization_policy
  to   = module.event_notification.time_sleep.wait_for_kms_authorization_policy
}
