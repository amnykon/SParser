import Foundation
import SParserPrivate
import SParserLibs

for inFile in CommandLine.arguments.dropFirst() {
  let inUrl = NSURL.fileURL(withPath: inFile)
  let outUrl = NSURL.fileURL(withPath: inFile + ".swift")
  print(outUrl)
  guard let inStream = try? UrlStream(from: inUrl) else {
    print("Error: Unable to open file \"\(inFile)\"")
    continue
  }
  let parser = Parser(stream: inStream)
  parser.isConvertingIndents = true
  do {
    let syntax = try parser.readSyntax()
    for rule in syntax ?? [] {
      print(rule.buildString())
    }
  } catch {
    print("Error while reading Syntax") /* TODO make more descriptive */
    continue
  }
}

/*
let path = FileManager.default.currentDirectoryPath
let dirUrl = NSURL.fileURL(withPath: path)
let fileUrl = dirUrl.appendingPathComponent("testReadChar.txt")
*/
