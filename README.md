# klickbert
klickbert is a tiny and native mac application that takes a screenshot every time you click your left mouse button or hit a key. It provides a wonderful way to visualize the progress of your next awesome project.

## File naming
Some metadata is encoded in the filename to ease later  postprocessing. A typical filename looks like this:
      
      2015-08-20T14;38;51+0200 -- LeftClick -- 54.000000x 7.003906y -- 1.png
      
It contains, divided by double dashes:

* Date similar to ISO 8601 but with `;` instead of `:`, since `:` is illegal in filenames (e.g. `2015-08-20T14;38;51+0200`),
* Type of Event, either `LeftClick` or `KeyDown`
* For mouse events: X and Y position of the click in cartesian coordinates (e.g. `0.00x 0.00y` as the *bottom left*, not top left),
* For key events: the character equivalent, e.g. `f`
* consecutive number of the screenshot (e.g. `42`).

## Interface
Currently, the only interface is a directory dialog that pops up on launch and asks you where to place the screenshots.

## Contributing
Would you like to make klickbert more kickass? If you have suggestions, I'd love to hear from you. Or even better, send me a pull request. Feature branches get bonus points.

