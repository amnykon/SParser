import Foundation
import SParserPrivate
import SParserLibs

var exitStatus: Int32 = 0

for inFile in CommandLine.arguments.dropFirst() {
  guard inFile.hasSuffix(".sparser") else {
    continue
  }
  let outFile = inFile.components(separatedBy: ".").dropLast().joined(separator: ".")

  let inUrl = NSURL.fileURL(withPath: inFile)
  let outUrl = NSURL.fileURL(withPath: outFile)
  print("\(inUrl.absoluteString) -> \(outUrl.absoluteString)")

  guard let inStream = try? UrlStream(from: inUrl) else {
    print("Error: Unable to open file \"\(inFile)\"")
    continue
  }
  let parser = Parser(stream: inStream)
  parser.isConvertingIndents = true
  do {
    let syntax = try parser.readSyntax()
    try syntax.buildString().write(to: outUrl, atomically: false, encoding: .utf8)
  } catch let error as ParserError {
    print(error.message)
    exitStatus = 1
    continue
  } catch {
    print("Error while reading Syntax") /* TODO make more descriptive */
    exitStatus = 1
    continue
  }
}

exit(exitStatus)
