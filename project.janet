(declare-project
  :name "janetui"
  :desc "janet bindings for the simple & portable GUI library libui: https://github.com/andlabs/libui"
  :url "https://github.com/janet-lang/janetui"
  :repo "https://github.com/janet-lang/janetui.git")

(def o (os/which))
(defn buildwithcmake [keyword]
    (do
      (pp [:START:::::: keyword])
      (pp (os/cwd))
      (os/cd "libui")
      (pp (os/cwd))
      (assert
        (and
          (zero?
            (os/execute ["cmake" "-B" "build" "-DBUILD_SHARED_LIBS=OFF"] :p))
          (zero?
            (os/execute ["cmake" "--build" "build"] :p))))
      (pp (os/cwd))
      (os/cd "..")
      (pp (os/cwd))
      (pp [:DONE::::::::: keyword])))

# when trying to not calling this in root, then the build process is jumbled around.... idk how to explain...
#comment this line to see it not finding main.c while buildwithcmake is still running:
(buildwithcmake :building-static-libui-with-cmake-now)

(rule "libui/build/out/libui.a" ["libui"]
    (buildwithcmake :building-static-libui-with-cmake-now:WITH:::::::::::::::::RULE))

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