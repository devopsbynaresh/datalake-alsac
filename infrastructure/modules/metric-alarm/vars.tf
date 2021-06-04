variable "create_metric_alarm" {
  description = "Whether to create the Cloudwatch metric alarm"
  type        = bool
  default     = true
}

variable "alarm_name" {
  description = "The descriptive name for the alarm. This name must be unique within the user's AWS account."
  type        = string
}

variable "alarm_description" {
  description = "The description for the alarm."
  type        = string
  default     = null
}

variable "comparison_operator" {
  description = "The arithmetic operation to use when comparing the specified Statistic and Threshold. The specified Statistic value is used as the first operand. Either of the following is supported: GreaterThanOrEqualToThreshold, GreaterThanThreshold, LessThanThreshold, LessThanOrEqualToThreshold."
  type        = string
}

variable "evaluation_periods" {
  description = "The number of periods over which data is compared to the specified threshold."
  type        = number
}

variable "threshold" {
  description = "The value against which the specified statistic is compared."
  type        = number
}

variable "unit" {
  description = "The unit for the alarm's associated metric."
  type        = string
  default     = null
}

variable "metric_name" {
  description = "The name for the alarm's associated metric. See docs for supported metrics."
  type        = string
  default     = null
}

variable "namespace" {
  description = "The namespace for the alarm's associated metric. See docs for the list of namespaces. See docs for supported metrics."
  type        = string
  default     = null
}

variable "period" {
  description = "The period in seconds over which the specified statistic is applied."
  type        = string
  default     = null
}

variable "statistic" {
  description = "The statistic to apply to the alarm's associated metric. Either of the following is supported: SampleCount, Average, Sum, Minimum, Maximum"
  type        = string
  default     = null
}

variable "actions_enabled" {
  description = "Indicates whether or not actions should be executed during any changes to the alarm's state. Defaults to true."
  type        = bool
  default     = true
}

variable "datapoints_to_alarm" {
  description = "The number of datapoints that must be breaching to trigger the alarm."
  type        = number
  default     = null
}

variable "dimensions" {
  description = "The dimensions for the alarm's associated metric."
  type        = map(string)
  default     = null
}

variable "alarm_actions" {
  description = "The list of actions to execute when this alarm transitions into an ALARM state from any other state. Each action is specified as an Amazon Resource Name (ARN)."
  type        = list(string)
  default     = null
}

variable "insufficient_data_actions" {
  description = "The list of actions to execute when this alarm transitions into an INSUFFICIENT_DATA state from any other state. Each action is specified as an Amazon Resource Name (ARN)."
  type        = list(string)
  default     = null
}

variable "ok_actions" {
  description = "The list of actions to execute when this alarm transitions into an OK state from any other state. Each action is specified as an Amazon Resource Name (ARN)."
  type        = list(string)
  default     = null
}

variable "extended_statistic" {
  description = "The percentile statistic for the metric associated with the alarm. Specify a value between p0.0 and p100."
  type        = string
  default     = null
}

variable "treat_missing_data" {
  description = "Sets how this alarm is to handle missing data points. The following values are supported: missing, ignore, breaching and notBreaching."
  type        = string
  default     = "missing"
}

variable "evaluate_low_sample_count_percentiles" {
  description = "Used only for alarms based on percentiles. If you specify ignore, the alarm state will not change during periods with too few data points to be statistically significant. If you specify evaluate or omit this parameter, the alarm will always be evaluated and possibly change state no matter how many data points are available. The following values are supported: ignore, and evaluate."
  type        = string
  default     = null
}

variable "metric_query" {
  description = "Enables you to create an alarm based on a metric math expression. You may specify at most 20."
  type        = any
  default     = []
}

######## Resource Tagging ########

variable "name_tag" {
  type = string
  description = "Resource Name - unique naming convention"
  default = ""
}

variable "application_name_tag" {
  type = string
  description = "Application Name - MRE|Cognos|MPSC..."
  default = ""
}

variable "owneremail_tag" {
  type = string
  description = "App/Product Owner - email address"
  default = ""
}

variable "environment_tag" {
  type = string
  description = "Application Stage - Common|Prod|Dev"
  default = ""
}

variable "role_tag" {
  type = string
  description = "Service Radius - Web|Data|Cache"
  default = ""
}

variable "createdate_tag" {
  type = string
  description = "Resource Creation - date"
  default = ""
}

variable "createby_tag" {
  type = string
  description = "Resource Created By - userid"
  default = ""
}

variable "lineofbusiness_tag" {
  type = string
  description = "Financial - global|APAC|NA|EU..."
  default = ""
}

variable "customer_tag" {
  type = string
  description = "Financial (same as country) - WW|UK|US..."
  default = ""
}

variable "costcenter_tag" {
  type = string
  description = "Code provided directly from Finance"
  default = ""
}

variable "approver_tag" {
  type = string
  description = "Financial - email address"
  default = ""
}

variable "lifespan_tag" {
  type = string
  description = "Financial - date to be reviewed"
  default = ""
}

variable "service-hours_tag" {
  type = string
  description = "Automation - FullTime|Weekdays..."
  default = ""
}

variable "compliance_tag" {
  type = string
  description = "Security - PCI|PII"
  default = ""
}

variable "project_team" {
  type = string
  description = "Project team in charge of the resource"
  default = ""
}
