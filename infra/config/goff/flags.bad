# GO Feature Flag – flag definitions
# This file is rendered into the ConfigMap as flags.yaml
enable_provisional_resolution:
  defaultVariation: false
  variations:
    - true
    - false
  targeting:
    - key: jurisdiction_fips
      operator: in
      values:
        - "06"   # California gets the feature
      variation: true

enable_realtime_results:
  defaultVariation: true
  variations:
    - true
    - false

audit_log_verbose:
  defaultVariation: false
  variations:
    - true
    - false
