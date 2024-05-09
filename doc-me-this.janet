#!/usr/bin/env janet
(import janetui :as ui)

(defn main [& args]
    (let [w (ui/window "doc-me-this" 500 250 true)
          outerbox (ui/vertical-box)
          entrybox (ui/search-entry )
          biglabel (ui/multiline-entry)]
      (ui/entry/on-changed entrybox |(let [entry (ui/entry/text entrybox)
                                            doctext (let [buffer (buffer/new 4096)]
                                                      (with-dyns [*out* buffer]
                                                        (when (> (length entry) 0)
                                                          (doc* entry)
                                                          (doc* (symbol entry))))
                                                      (string buffer))]
                                            (ui/multiline-entry/text biglabel doctext)))
      (ui/box/append outerbox entrybox)
      (ui/box/append outerbox biglabel true)
      (ui/window/set-child w outerbox)
      (ui/show w))
    (ui/main))