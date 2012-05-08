(tcp-server)
(udp-server)

(def graph (graphite {:host "localhost"}))

(let [
      ; Streams that take events, transform them into a specific type of metric,
      ; and send them along to graphite.

      occurrenceify #(adjust [:service str " occurences"]
                             (with {:metric 1.0}
                                   graph))

      meterify #(adjust [:service str " per-second"]
                        (default {:metric 1.0}
                                 (fill-in-last 5 {:metric 0.0}
                                               (rate 5
                                                     graph))))


      histogramify #(adjust [:service str " value"]
                            (percentiles 5 [0.5 0.75 0.95 0.99 1.0]
                                         prn
                                         graph))


      rateify #(with {:metric 1.0}
                     (meterify))

      ; Streams that take events, look at their tags, and send them along to the
      ; appropriate metricizing stream(s).

      occurrences #(where (tagged "occurrence")
                          (occurrenceify))

      meters #(where (tagged "meter")
                     (meterify))

      histograms #(where (tagged "histogram")
                         (histogramify))

      timers #(where (tagged "timer")
                     (histogramify)
                     (rateify))

      ; Shortcut to send a stream along to all metrics.

      metrics #(default {}
                        (occurrences)
                        (meters)
                        (histograms)
                        (timers))

      ]
  (streams
    (partial prn "RAW")
    (by [:host :service]
        (metrics))

    (by [:service]
        (with {:host "all-hosts"}
              (metrics)))))
