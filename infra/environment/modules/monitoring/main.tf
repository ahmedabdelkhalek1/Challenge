resource "google_compute_health_check" "app_health_check" {
  name                = "app-health-check"
  check_interval_sec  = 10
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 2

  http_health_check {
    port         = 80
    request_path = "/"
  }
}

resource "google_monitoring_alert_policy" "app_unavailable_alert" {
  display_name = "App Unavailable Alert"
  combiner     = "OR"

  conditions {
    display_name = "App Health Check Failed"
    condition_threshold {
      filter          = "metric.type=\"compute.googleapis.com/instance/health\" resource.type=\"http_load_balancer\""
      duration        = "60s"
      comparison      = "COMPARISON_GT"
      threshold_value = 0
      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_RATE"
      }
    }
  }

  notification_channels = [] # Add notification channel IDs here
}
