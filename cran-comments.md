This package was previously submitted as 'Rwarrior', but is now submitted as 'rwarrior'.
This package has not yet existed on CRAN so the name change should not cause an issue. 

# Comments on previous rejection.

In order to support the function examples, the R/*.R files have been changed to 
handle user input function bugs, distinguishing them from bugs in 'rwarrior', 
with an informative alert danger message.

# Test Environments

* Local macOS 12.4, Apple M1 Chip, R 4.2.1
* Github Actions:
  * Ubuntu:
    * R 4.2.1
    * R devel_1_amd64
    * R 4.1.3
    * R 3.6.3
  * macOS, R 4.2.1
  * Windows, R 4.2.1
* win-builder
  * R release
  * R devel
  * R oldrelease
* R-hub builder, R devel

# R CMD check results
There were no ERRORs or WARNINGs. 

There was 1 or 2 NOTES depending on the platform:

Note 1:
```
Maintainer: 'Rick M Tankard <rickmtankard@gmail.com>'

New submission
```
Response: This is the first CRAN submission of rwarrior. 


Note 2:
```
* checking package dependencies ... NOTE
Package suggested but not available for checking: 'covr'
```
This was only a note on R-hub. 
covr package is used for code coverage, and won't be run on CRAN tests.


# Downstream dependencies
There are currently no downstream dependencies for this package.

