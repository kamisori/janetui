(declare-project
  :name "janetui"
  :desc "janet bindings for the simple & portable GUI library libui: https://github.com/andlabs/libui"
  :url "https://github.com/janet-lang/janetui"
  :repo "https://github.com/janet-lang/janetui.git")

# build with --workers=1

(def o (os/which))

(defn buildwithcmake []
    (do
      (os/cd "libui")
      ## need to make this error more verbose
      (assert
        (and
          (zero?
            (os/execute ["cmake" "-B" "build" "-DBUILD_SHARED_LIBS=OFF"] :p))
          (zero?
            (os/execute ["cmake" "--build" "build"] :p))) "! use jpm build --workers=1 !")
      (os/cd "..")))

(rule "libui/build/out/libui.a" ["libui"] (buildwithcmake))

(add-dep "build" "libui/build/out/libui.a")

(declare-native
  :name "janetui"
  :source ["main.c"]
  :cflags [;default-cflags ;(case o
                              :macos '["-Ilibui" "-Ilibui/darwin"]
                              :windows '["-Ilibui" "-Ilibui/windows" ]
                              #default
                              '["-Ilibui" "-Ilibui/unix"])]
  :lflags [;default-lflags ;(case o
                              :linux '[ "libui/build/out/libui.a" "-lglib-2.0" "-lgtk-3" "-lgdk-3"]
                              #default
                              '[ "libui/build/out/libui.a" "-lglib-2.0" "-lgtk-3" "-lgdk-3"])])

(comment 
(declare-executable
  :name "doc-me-this"
  :entry "doc-me-this.janet"
  :install false
  :deps [(native-module :static)])
)