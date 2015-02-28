# share-paths

Manage search paths provided by some gems.

[![Gem Version](https://badge.fury.io/rb/share-paths.svg)](http://badge.fury.io/rb/share-paths)
[![GitHub license](https://img.shields.io/badge/license-LGPLv3-orange.svg?style=flat)](https://raw.githubusercontent.com/shikhalev/share-paths/master/LICENSE)
[![Code Climate](https://codeclimate.com/github/shikhalev/share-paths/badges/gpa.svg)](https://codeclimate.com/github/shikhalev/share-paths)

## Usage

At gems place your share files in `<gemroot>/share` directory and add to source
code:

```Ruby
require 'share-paths'

Share::register_vendor_path
```

At application find share files by:

```Ruby
js = Share['js/myscript.js']
css = Share['css/darc.css']
```

## License

* [GNU Lesser General Public License v3](LICENSE)
