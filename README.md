# Simple Kriging App

This is just a simple PoC to test how well a shiny app runs which does some
ordinary kriging based on user input.  It has some very rudimentary caching.

The app has a number of dependencies besides `shiny`:

* `data.table`
* `leaflet`
* `gstat`
* `sp`
* `rgeos`
* `raster`
* `rgdal`

To run a version locally:

```r
shiny::runGitHub("cmhh/krigingapp")
```
