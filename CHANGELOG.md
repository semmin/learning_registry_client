# Changelog

## Version 0.0.1

** Created initial files and configuration **
** Created first class `LearningRegistry::Resource` **
** Added first method  `LearningRegistry::Resource.slice` **

_Sample Usage:_

    LearningRegistry::Resource.slice("science") {|resources, token, total| @resources, @token, @total = resources, token, total}
    LearningRegistry::Config.hydra.run