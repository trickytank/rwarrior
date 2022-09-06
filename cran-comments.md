This package was previously submitted as 'Rwarrior', but is now submitted as 'rwarrior'.
This package has not yet existed on CRAN so the name change should not cause an issue. 

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

There was 2 NOTES:
```
Maintainer: 'Rick M Tankard <rickmtankard@gmail.com>'

New submission
```
Response: This is the first CRAN submission of R Warrior. 


```
* checking for detritus in the temp directory ... NOTE
Found the following files/directories:
  'lastMiKTeXException'
```
As noted in [R-hub issue #503](https://github.com/r-hub/rhub/issues/503), this seems like a bug/crash in MiKTeX and can thus probably be ignored. This only cropped up on R-Hub. 

# Downstream dependencies
There are currently no downstream dependencies for this package.
