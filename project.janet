(declare-project
  :name "janetui"
  :desc "janet bindings for the simple & portable GUI library libui: https://github.com/andlabs/libui"
  :url "https://github.com/janet-lang/janetui"
  :repo "https://github.com/janet-lang/janetui.git")

(def o (os/which))

(def cflags
  (case o
    :macos '["-Ilibui" "-Ilibui/darwin"]
    :windows ["-Ilibui" "-Ilibui/windows" ]
    #default
    '["-Ilibui" "-Ilibui/unix"]))

(def lflags
  (case o
    :linux '[ "build/libui/out/ui.a" "-lglib-2.0" "-lgtk-3" "-lgdk-3"]
    #default
    '[ "build/libui/out/ui.a" "-lglib-2.0" "-lgtk-3" "-lgdk-3"]))


(declare-bin
  :main "./build/janetui.so")

(rule "cmake" ["CMakeLists.txt"]
      (do
        (assert
          (and
            (zero?
              (os/execute ["cmake" "-B" "build"] :p))
            (zero?
              (os/execute ["cmake" "--build" "build"] :p)) "--build build"))))

(add-input "build" "cmake")
(add-output "cmake" "build/libui/out/ui.a")

(declare-native
  :name "janetui"
  :source ["main.c"]
  :cflags [;default-cflags ;cflags]
  :lflags [;default-lflags ;lflags])

(comment 
(declare-executable
  :name "uwudemo"
  :entry "test.janet"
  :install false)
)