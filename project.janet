(declare-project
  :name "janetui"
  :desc "janet bindings for the simple & portable GUI library libui: https://github.com/andlabs/libui"
  :url "https://github.com/janet-lang/janetui"
  :repo "https://github.com/janet-lang/janetui.git")

(def o (os/which))

(rule "build/janetui.so" ["CMakeLists.txt"]
      (do
        (assert
          (and
            (zero?
              (os/execute ["cmake" "-B" "build"] :p))
            (zero?
              (os/execute ["cmake" "--build" "build"] :p)) "--build build"))))

(add-dep "build" "build/janetui.so")

(declare-native
  :name "janetui"
  :source ["main.c"]
  :cflags [;default-cflags ;(case o
                              :macos '["-Ilibui" "-Ilibui/darwin"]
                              :windows ["-Ilibui" "-Ilibui/windows" ]
                              #default
                              '["-Ilibui" "-Ilibui/unix"])]
  :lflags [;default-lflags ;(case o
                              :linux '[ "build/libui/out/ui.a" "-lglib-2.0" "-lgtk-3" "-lgdk-3"]
                              #default
                              '[ "build/libui/out/ui.a" "-lglib-2.0" "-lgtk-3" "-lgdk-3"])])


#(declare-executable
#  :name "doc-me-this"
#  :entry "doc-me-this.janet")

(comment 
(declare-executable
  :name "uwudemo"
  :entry "test.janet"
  :install false)
)