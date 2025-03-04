//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2021-2022 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
//
//===----------------------------------------------------------------------===//

@_silgen_name("_swift_stdlib_getScript")
func _swift_stdlib_getScript(_: UInt32) -> UInt8

@_silgen_name("_swift_stdlib_getScriptExtensions")
func _swift_stdlib_getScriptExtensions(
  _: UInt32,
  _: UnsafeMutablePointer<UInt8>
) -> UnsafePointer<UInt8>?

extension Unicode.Script {
  init(_ scalar: Unicode.Scalar) {
    let rawValue = _swift_stdlib_getScript(scalar.value)
    
    _internalInvariant(rawValue != .max, "Unknown script rawValue: \(rawValue)")
    
    self = unsafeBitCast(rawValue, to: Self.self)
  }
  
  static func extensions(for scalar: Unicode.Scalar) -> [Unicode.Script] {
    var count: UInt8 = 0
    let pointer = _swift_stdlib_getScriptExtensions(scalar.value, &count)
    
    guard let pointer = pointer else {
      return [Unicode.Script(scalar)]
    }
    
    var result: [Unicode.Script] = []
    
    for i in 0 ..< count {
      let script = pointer[Int(i)]
      
      result.append(unsafeBitCast(script, to: Unicode.Script.self))
    }
    
    return result
  }
}
