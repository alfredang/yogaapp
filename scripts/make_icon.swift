import AppKit
import ImageIO
import UniformTypeIdentifiers

// ZenAsana app icon — a calm sage gradient with a white lotus motif. No alpha (App Store requires).
// usage: swift make_icon.swift /path/to/icon-1024.png

let px = 1024
let out = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : "/tmp/icon-1024.png"
// Draw into an RGBA rep (CGBitmapContext requires an alpha channel), strip it on output.
let rep = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: px, pixelsHigh: px,
  bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false,
  colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0)!
NSGraphicsContext.saveGraphicsState()
NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)
let ctx = NSGraphicsContext.current!.cgContext
let S = CGFloat(px)
let full = NSRect(x: 0, y: 0, width: S, height: S)

// Calm diagonal sage-teal gradient.
let start = NSColor(srgbRed: 0.27, green: 0.57, blue: 0.50, alpha: 1)
let end   = NSColor(srgbRed: 0.15, green: 0.38, blue: 0.34, alpha: 1)
NSGradient(starting: start, ending: end)!.draw(in: full, angle: -60)
// Soft top highlight.
let hi = NSGradient(colors: [NSColor(white: 1, alpha: 0.16), NSColor(white: 1, alpha: 0)])!
hi.draw(in: full, relativeCenterPosition: NSPoint(x: -0.3, y: 0.55))

// Lotus petals centered slightly above middle.
let cx = S/2, cy = S*0.47
let white = NSColor(white: 1, alpha: 0.96)
let whiteSoft = NSColor(white: 1, alpha: 0.78)

func petal(angle: CGFloat, length: CGFloat, width: CGFloat, color: NSColor) {
    ctx.saveGState()
    ctx.translateBy(x: cx, y: cy)
    ctx.rotate(by: angle)
    let p = NSBezierPath()
    p.move(to: NSPoint(x: 0, y: 0))
    p.curve(to: NSPoint(x: 0, y: length),
            controlPoint1: NSPoint(x: width, y: length*0.45),
            controlPoint2: NSPoint(x: width*0.35, y: length*0.92))
    p.curve(to: NSPoint(x: 0, y: 0),
            controlPoint1: NSPoint(x: -width*0.35, y: length*0.92),
            controlPoint2: NSPoint(x: -width, y: length*0.45))
    color.setFill(); p.fill()
    ctx.restoreGState()
}

// Back petals (wider, softer).
let backLen = S*0.30, backW = S*0.135
petal(angle: -0.95, length: backLen, width: backW, color: whiteSoft)
petal(angle:  0.95, length: backLen, width: backW, color: whiteSoft)
petal(angle: -0.50, length: backLen*1.05, width: backW, color: whiteSoft)
petal(angle:  0.50, length: backLen*1.05, width: backW, color: whiteSoft)

// Front petals (taller, brighter).
let frontLen = S*0.34, frontW = S*0.115
petal(angle: -0.22, length: frontLen, width: frontW, color: white)
petal(angle:  0.22, length: frontLen, width: frontW, color: white)
petal(angle:  0.0,  length: frontLen*1.06, width: frontW, color: white)

NSGraphicsContext.restoreGraphicsState()

// Strip alpha: redraw the RGBA image into a noneSkipLast (opaque) CG context, encode that.
let srcCG = rep.cgImage!
let opaque = CGContext(data: nil, width: px, height: px, bitsPerComponent: 8, bytesPerRow: 0,
    space: CGColorSpaceCreateDeviceRGB(),
    bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)!
opaque.draw(srcCG, in: CGRect(x: 0, y: 0, width: S, height: S))
let outCG = opaque.makeImage()!

let url = URL(fileURLWithPath: out)
let dest = CGImageDestinationCreateWithURL(url as CFURL, UTType.png.identifier as CFString, 1, nil)!
CGImageDestinationAddImage(dest, outCG, nil)
guard CGImageDestinationFinalize(dest) else {
    FileHandle.standardError.write("PNG encode failed\n".data(using: .utf8)!); exit(1)
}
print("Wrote \(out)")
