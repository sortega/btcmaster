name := "bitjvm"

scalaVersion := "2.12.4"

resolvers += "Artima Maven Repository" at "http://repo.artima.com/releases"

libraryDependencies ++= Seq(
  "org.bitcoinj"  % "bitcoinj-core" % "0.14.5",
  "org.scalatest" %% "scalatest"    % "3.0.4" % "test"
)
