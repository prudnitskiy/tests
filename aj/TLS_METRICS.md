# TLS proxy server metrics

Those metrics intends we use Linux (or other UNIX).

- OS level
  - CPU per-class activity (user, sys, io, irq, wait)
  - per-core CPU usage (to ensure we don't have underbalancing)
  - CPU waiting queue
  - memory usage
  - disk usage (R/W queues, bandiwth)
  - swap in-outs (should be about zero)
  - CPU context switches
  - File descriptors opened
- Network interface level
  - bandiwdth (bps)
  - packets (pps)
  - RX/TX errors
- TCP stack level
  - TCP sessions - per status grouping
  - TCP retransmissions
  - TCP buffer size
  - TCP stack memory usage
- Application level
  - Connection latency
  - Connections rate
  - Errors
  - Saturation
  - Cache saturation
  - In-app memory usage
