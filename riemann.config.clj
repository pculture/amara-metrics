(tcp-server)
(udp-server)

(def graph (graphite {:host "localhost"}))

(defn add-environ-name
  "Add the environment name to the hostname, based on the presence of a tag."
  [{:keys [tags host] :as event}]
  (let [tags (set tags)]
    (cond
      (tags "production") (update-in event [:host] str ".production")
      (tags "staging")    (update-in event [:host] str ".staging")
      (tags "dev")        (update-in event [:host] str ".dev")
      :else               event)))

(defn add-environ-name-combined
  [{:keys [tags host] :as event}]
  (let [tags (set tags)]
    (assoc event :host (cond
                         (tags "production") "all-hosts.production"
                         (tags "staging")    "all-hosts.staging"
                         (tags "dev")        "all-hosts.dev"
                         :else               "all-hosts"))))


(let [
      ; Streams that take events, transform them into a specific type of metric,
      ; and send them along to graphite.

      occurrenceify #(adjust [:service str " occurences"]
                             (with {:metric 1.0}
                                   graph))

      meterify #(adjust [:service str " rate-per-second"]
                        (default {:metric 1.0}
                                 (fill-in-last 5 {:metric 0.0}
                                               (rate 5
                                                     graph))))


      histogramify #(adjust [:service str " value"]
                            (percentiles 5 [0.5 0.75 0.95 0.99 1.0]
                                         graph))


      ; Streams that take events, look at their tags, and send them along to the
      ; appropriate metricizing stream(s).

      occurrences #(where (tagged "occurrence")
                          (occurrenceify))

      meters #(where (tagged "meter")
                     (meterify))

      histograms #(where (tagged "histogram")
                         (histogramify))

      timers #(where (tagged "timer")
                     (histogramify))

      ; Gauges are special -- they're super simple.

      gauges #(where (tagged "gauge")
                     graph)

      ; Shortcut to send a stream along to all metrics.

      metrics #(default {}
                        (occurrences)
                        (meters)
                        (histograms)
                        (timers)
                        (gauges))
      ]
  (streams
    (with {:host "riemann" :service "raw-events-processed" :metric 1.0}
          (fill-in-last 5 {:metric 0.0}
                        (rate 5 graph)))

    (adjust add-environ-name
            (by [:host :service]
                (metrics)))

    (adjust add-environ-name-combined
            (by [:host :service]
                (metrics)))))
