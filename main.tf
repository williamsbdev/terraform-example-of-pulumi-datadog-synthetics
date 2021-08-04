terraform {
  required_providers {
    datadog = {
      source = "DataDog/datadog"
    }
  }
}

variable "datadog_api_key" {
  type = string
}

variable "datadog_app_key" {
  type = string
}

provider "datadog" {
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
}

resource "datadog_synthetics_test" "test_api" {
  type    = "api"
  subtype = "http"
  request_definition {
    method = "GET"
    url    = "http://example.com"
  }
  assertion {
    type     = "statusCode"
    operator = "is"
    target   = "200"
  }
  assertion {
    type     = "responseTime"
    operator = "lessThan"
    target   = "1000"
  }
  locations = ["aws:us-west-1"]
  options_list {
    tick_every           = 60
    min_failure_duration = 300
    min_location_failed  = 1
    follow_redirects     = false
  }
  name    = "Test for http://example.com"
  message = "Notify @pagerduty"

  tags = [
    "env:prod"
  ]
  status = "live"
}
