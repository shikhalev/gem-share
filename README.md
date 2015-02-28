# share-paths

Manage search paths provided by some gems.


## Usage

At gems place your share files in `<gemroot>/share` directory and add to source
code:

```Ruby
require 'share-paths'

Share.register_vendor_path
```

At application find share files by:

```Ruby
js = Share['js/myscript.js']
css = Share['css/darc.css']
```

## License

* [GNU Lesser General Public License v3](LICENSE)
