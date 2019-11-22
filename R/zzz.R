.onLoad <- function(libname, pkgname) {
  packageStartupMessage("       package climproxyrecords has moved to GitHub, https://github.com/EarthSystemDiagnostics/climproxyrecords
        install directly with devtools::install_github(\"EarthSystemDiagnostics/climproxyrecords\")
        or update your remote.

        # to print the current settings
        git remote -v

        # to change origin to the new url
        git remote set-url origin git@github.com:username/repo-name.git")
}