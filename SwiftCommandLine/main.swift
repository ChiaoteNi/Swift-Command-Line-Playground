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

// 3. How to read / write Environments:
// Read
let environments = ProcessInfo.processInfo.environment
print("💥environments =", environments)
print("💥getENV =", String(utf8String: getenv("HOME"))!)
print("💥PATH =", String(describing: environments["PATH"]))

// Write
if let rawValue = getenv("YO") {
    print("💥getENVYO =", String(utf8String: rawValue) ?? "nil")
}
setenv("YO", "yo123", 1)
if let rawValue = getenv("YO") {
    print("💥getENVYO =", String(utf8String: rawValue) ?? "nil")
}
