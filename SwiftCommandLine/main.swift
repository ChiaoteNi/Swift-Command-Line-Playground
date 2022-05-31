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

// 4. How to get current position:
let currentPath = Process().currentDirectoryPath
print("💥You're now at ", currentPath)

// 5. How to run script inside Swift CommandLine
func sh(_ command: String) throws {
    let process = Process()
    process.launchPath = "/bin/bash"
    process.arguments = ["-c", command]

    // Because FileHandle's readabilityHandler might be called from a
    // different queue from the calling queue, avoid a data race by
    // protecting reads and writes to outputData and errorData on
    // a single dispatch queue.
    let outputQueue = DispatchQueue(label: "bash-output-queue")

    var outputData = Data()
    let outputPipe = Pipe()
    process.standardOutput = outputPipe

    var errorData = Data()
    let errorPipe = Pipe()
    process.standardError = errorPipe

    outputPipe.fileHandleForReading.readabilityHandler = { handler in
        let data = handler.availableData
        outputQueue.async {
            outputData.append(data)
        }
    }

    errorPipe.fileHandleForReading.readabilityHandler = { handler in
        let data = handler.availableData
        outputQueue.async {
            errorData.append(data)
        }
    }

    process.launch()
    process.waitUntilExit()

    outputPipe.fileHandleForReading.readabilityHandler = nil
    errorPipe.fileHandleForReading.readabilityHandler = nil

    try outputQueue.sync {
        print(command)
        if process.terminationStatus == 0 {
            print("💥", outputData.utf8String())
        } else {
            let message = "Reason=\(process.terminationReason) \n\(errorData.utf8String())"
            throw NSError(
                domain: NSCocoaErrorDomain,
                code: Int(process.terminationStatus),
                userInfo: [NSLocalizedDescriptionKey: message]
            )
        }
    }
}

private extension Data {
    func utf8String() -> String {
        return String(data: self, encoding: .utf8) ?? "💥"
    }
}

do {
//    try sh("mkdir ../YAYAYA")
    try sh("git status")
//    try sh("git add .")
    try sh("echo YAYAYO")
    try sh("ls ..")
} catch {
    print("🤢", error)
}
