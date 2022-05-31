import Foundation

// 1. How to echo:
print("Hello, World!")

// 2. How to read the arguments:
// ex: SwiftCommandLine -path "www.google.com"
// arguments = [currentPath, "-path", "www.google.com"]
// Now you know how --help works
let arguments = ProcessInfo.processInfo.arguments
print("💥arguments =", arguments)
print("💥CommandLine.arguments = ", CommandLine.arguments)
