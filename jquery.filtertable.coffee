# ###
# jquery.filterTable

# This plugin will add a search filter to tables. When typing in the filter,
# any rows that do not contain the filter will be hidden.

# Utilizes bindWithDelay() if available. https://github.com/bgrins/bindWithDelay

# @version v1.5
# @author Sunny Walker, swalker@hawaii.edu
# @author Tomas Celizna, tomas.celizna@gmail.com
# ###
(($, window) ->



  # ---------------------------------------------------------------------



  pluginName = 'filterTable'
  document = window.document

  defaults =
    callback: null # callback function after a filter is performed. function (str, $table)
    columnSelector: 'td' # filter applied to table cells (td)
    containerClass: 'filter-table' # class of filter input container
    containerTag: 'p' # tag name of filter input container
    highlightClass: 'alt' # class added to matching table cells (td)
    inputName: 'filter-table' # name of filter input
    inputPlaceholder: 'search this table' # placholder in filter input
    inputType: 'search' # type of filter input
    inputLabel: 'Filter:' # label added before the filter input (null for no label)
    minRows: 8 # only show the filter on tables with this number of rows or more
    quickList: [] # list of phrases to quick fill the search
    quickListContainerClass: 'quick' # class of quick list container
    quickListContainerTag: 'ol' # tag name of quick list container
    quickListItemClass: 'quick' # class of each quick list item
    quickListItemTag: 'li' # tag name of each quick list item
    rowSelector: 'tbody > tr' # selector applied to table rows (tr)
    visibleClass: 'visible' # class added to visible rows



  # ---------------------------------------------------------------------



  class Plugin



    constructor: (@element, options) ->
      @options = $.extend {}, defaults, options

      @$element = $(@element)

      # cache rows to filter
      @$rows = @$element.find(@options.rowSelector)
      # variable for filter container
      @$filter_container = null
      # variable for quick list container
      @$quick_list_container = null

      @_defaults = defaults
      @_name = pluginName

      @init()



    init: ->
      return unless @$element.is('table')
      return unless @$rows.length >= @options.minRows

      @build_selector()
      @build_filter()
      @build_quick_list()


      
    # ---------------------------------------------------------------------
      
      
    
    filter_table: (str) ->
      if str == ''
        @show_all_rows()
      else
        @hide_all_rows()
        
        filter_selector = @get_filter_selector(str)

        $found_cells = @$rows.find(@options.columnSelector).filter(filter_selector)
        $found_cells.addClass(@options.highlightClass)

        $found_rows = $found_cells.closest('tr')
        $found_rows.show().addClass(@options.visibleClass)
    
      @options.callback(str, @$element) if @options.callback

    
    
    # ---------------------------------------------------------------------
    
    
    
    show_all_rows: ->
      @$rows.show().addClass(@options.visibleClass)
      @$rows.find("td.#{@options.highlightClass}").removeClass(@options.highlightClass)

    hide_all_rows: ->
      @$rows.hide().removeClass(@options.visibleClass)
      @$rows.find('td').removeClass(@options.highlightClass)

    
    
    # ---------------------------------------------------------------------
    
    

    get_clean_str: (str) ->
      str.replace(/(['"])/g, "\\$1")
    
    get_filter_selector: (str) ->
      ":filterTableFind(\"#{@get_clean_str(str)}\")"

    
    
    # ---------------------------------------------------------------------
    
    
    
    build_selector: ->
      $.expr[":"].filterTableFind = (a, i, m) ->
        $(a).text().toUpperCase().indexOf(m[3].toUpperCase()) >= 0

    build_filter_container: ->
      $("<#{@options.containerTag} />").addClass(@options.containerClass)

    build_filter_input: ->
      $("<input type='#{@options.inputType}' placeholder='#{@options.inputPlaceholder}' name='#{@options.inputName}' />")

    build_filter_label: ->
      return unless @options.inputLabel
      $("<label for='#{@options.inputName}' />").html(@options.inputLabel)

    build_filter: ->
      @$filter_container = @build_filter_container()

      $input = @build_filter_input()
      $label = @build_filter_label()

      @$filter_container.append($label) if $label
      @$filter_container.append($input)

      if $.fn.bindWithDelay
        $input.bindWithDelay 'keyup', ((e) => @filter_table $(e.target).val() ), 200
      else
        $input.on 'keyup', ((e) => @filter_table $(e.target).val())

      $input.on 'click search', ((e) => @filter_table $(e.target).val())

      @$element.before @$filter_container

    
    
    # ---------------------------------------------------------------------
    
    
    
    build_quick_list_container: ->
      $("<#{@options.quickListContainerTag} />").addClass(@options.quickListContainerClass)

    build_quick_list_item: (str) ->
      clean_str = str.replace(/&/g, "&amp;").replace(/"/g, "&quot;").replace(/</g, "&lt;").replace(/>/g, "&gt;")
      $item = $("<#{@options.quickListItemTag} />").addClass(@options.quickListItemClass)
      $link = $("<a href='#' />").html(clean_str)

      $item.append $link

    build_quick_list: ->
      return unless @options.quickList.length > 0

      @$quick_list_container = @build_quick_list_container()

      for str in @options.quickList
        $item = @build_quick_list_item(str)
        @$quick_list_container.append $item

      @$quick_list_container.on 'click', 'a', (e) =>
        e.preventDefault()
        str = $(e.target).html()
        $input = @$filter_container.find("input")
        $input.val(str).focus().trigger('click')

      @$element.before @$quick_list_container



  # ---------------------------------------------------------------------



  # prevents multiple instantiation on same DOM element
  $.fn[pluginName] = (options) ->
    @each ->
      if !$.data(this, "plugin_#{pluginName}")
        $.data(@, "plugin_#{pluginName}", new Plugin(@, options))



  # ---------------------------------------------------------------------



)(jQuery, window)