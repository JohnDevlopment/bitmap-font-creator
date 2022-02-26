# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1]
### Added
* "Properties" tab
* Undo/redo functionality in the "Properties" tab
* String property control
* New dialog for inserting a range of characters easily into the font
* `BFCHelpers` singleton for implementing common and useful functions
* Example `BitmapFont` for the user to look at

### Changed

* Made character map grid 3 columns instead of 2
* Inspector no longer displays properties under `BitmapFont`
* Added label to Vector2 property control

## [1.0]
### Added

* Debug messages (enable with "Bitmap Font Plugin/Print Messages" under the project settings)
* Icon for the plugin (in plugin folder)
* Grid drawn on texture when the vframes and hframes are changed
* Textures are labeled with their ID so you don't have to guess

### Fixed

* Fixed texture count not updating when a texture was deleted

## [0.2] - 02/22/22
### Changed

* Use of a 2d vector to specify which cell in the texture to use for a character as opposed to an index

## 0.1 - 02/20/22

* This is the initial version of the plugin. Hopefully when the first official release comes, it will be useful to you

### Added

* The ability to divide textures into cells and to specify which cell you want to map to which character
* Use multiple textures for one font

[Unreleased]: https://github.com/JohnDevlopment/bitmap-font-creator/compare/v1.1...HEAD
[1.1]: https://github.com/JohnDevlopment/bitmap-font-creator/compare/v1.0...v1.1
[1.0]: https://github.com/JohnDevlopment/bitmap-font-creator/compare/v0.2...v1.0
[0.2]: https://github.com/JohnDevlopment/bitmap-font-creator/compare/v0.1...v0.2
