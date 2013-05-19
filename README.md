# jQuery Filter Table Plugin

This plugin will add a search filter to tables. When typing in the filter, any rows that do not contain the filter will be hidden.

One can also define clickable shortcuts for commonly used terms.

See the demos at http://sunnywalker.github.com/jQuery.FilterTable

## Usage

Include the dependencies:

```html
<script src="/path/to/jquery.js"></script>
<script src="/path/to/bindWithDelay.js"></script> <!-- optional -->
<script src="/path/to/jquery.filtertable.js"></script>
<style>
p.filter-table { margin: 0; }
ol.quick { margin: 0; margin-bottom: 1em; padding: 0; list-style: none; }
ol.quick li { display: inline; margin-right: 10px; }
td.alt { background-color: #ffc; background-color: rgba(255, 255, 0, 0.2); }
</style> <!-- or put the styling in your stylesheet -->
```

Then apply `filterTable()` to your table(s):

```html
<script>
$('table').filterTable(); //if this code appears after your tables; otherwise, include it in your document.ready() code.
</script>
```

## Options

| Option | Type | Default | Description |
| ------ | ---- | ------- | ----------- |
| `callback` | function(`term`, `$table`) | _null_ | callback function after a filter is performed
| `columnSelector` | string | td | selector of table cells (td)
| `containerClass` | string | filter-table | class of filter input container
| `containerTag` | string | p | tag name of filter input container
| `highlightClass` | string | alt | class added to matching table cells (td)
| `inputName` | string | filter-table | name of filter input
| `inputPlaceholder` | string | search this table | placholder in filter input
| `inputType` | string | search | type of filter input
| `inputLabel` | string | Filter: | label added before the filter input (null for no label)
| `minRows` | integer | 8 | only show the filter on tables with this number of rows or more
| `quickList` | array | [] | list of phrases to quick fill the search
| `quickListContainerClass` | string | quick | class of quick list container
| `quickListContainerTag` | string | ol | tag name of quick list container
| `quickListItemClass` | string | quick | class of each quick list item
| `quickListItemTag` | string | li | tag of each quick list item
| `rowSelector` | string | tbody > tr | selector applied to table rows (tr)
| `visibleClass` | string | visible | class added to visible rows

## Styling

Suggested styling:

```css
p.filter-table { margin: 0; }
ol.quick { margin: 0; margin-bottom: 1em; padding: 0; list-style: none; }
ol.quick li { display: inline; margin-right: 10px; }
td.alt { background-color: #ffc; background-color: rgba(255, 255, 0, 0.2); }
```

There is a caveat on automatic row striping. While alternating rows can be striped with CSS, such as:

```css
tbody td:nth-child(even) { background-color: #f0f8ff; }
```

Note that CSS cannot differentiate between visible and non-visible rows. To that end, it's better to use jQuery to add and remove a striping class to visible rows by defining a callback function in the options.

```javascript
$('table').filterTable({
	callback: function(term, table) {
		table.find('tr').removeClass('striped').filter(':visible:').addClass('striped');
	}
});
```

## Dependencies

Other than jQuery, the plugin will take advantage of Brian Grinstead's [bindWithDelay](https://github.com/bgrins/bindWithDelay) if it is available.

## Change Log

### 1.5

- Rewrite to CoffeeScript
- Support for custom row and cell selectors
- Adjustments to generated markup (quick list is now a real list)
- Further options to customize markup (tag and class names)

### 1.4

- Fixed a bug with filtering rarely showing rows that did not have a match with the search query.
- Added example pages.
- Improved inline documentation of the source code.

### 1.3

- The functionality is not reapplied to tables that have already been processed. This allows you to call `$(selector).filterTable()` again for dynamically created data without it affecting previously filtered tables.

### 1.2

- Changed the default container class to `filter-table` from `table-filter` to be consistent with the plugin name.
- Made the cell highlighting class an option rather than hard-coded.

### 1.1

- Initial public release.

## License

(The MIT License)

Copyright (c) 2013 Sunny Walker <swalker@hawaii.edu> & Tomas Celizna <tomas.celizna@gmail.com>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the 'Software'), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
