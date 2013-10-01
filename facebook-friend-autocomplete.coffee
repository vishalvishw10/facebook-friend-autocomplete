String::contains = (sub) ->
  @indexOf(sub) > -1

do ($ = jQuery, window, document) ->

  pluginName = "facebookAutocomplete"
  defaults =
    showAvatars: true
    maxSuggestions: 6
    onpick: undefined

  class Plugin
    constructor: (@element, options) ->
      @element = $(@element)
      @settings = $.extend({}, defaults, options)
      @_defaults = defaults
      @_name = pluginName
      @init()

    init: ->
      @friends = @getFriendList()
      @list = @createSuggestionList()

      @element.on 'keyup.fbac', (e) =>
        switch e.which
          # DOWN ARROW
          when 40 then @pickChange('down')
          # UP ARROW
          when 38 then @pickChange('up')
          # ENTER
          when 13 then @submit()
          # EVERYTHING ELSE
          else @filter($(e.currentTarget).val())

      @list.on 'click', '.fbac-suggestion', (e) =>
        @currentPick = $(e.currentTarget)
        @submit()

      @list.on 'mouseover', '.fbac-suggestion', (e) =>
        @currentPick.removeClass('fbac-current-pick')
        @currentPick = $(e.currentTarget).addClass('fbac-current-pick')

    getFriendList: ->
      friends = []
      url = '/me/friends/?fields=name'
      url += ',picture' if @settings.showAvatars
      FB.api url, (response) =>
        for friend in response.data
          friends.push({
            id: friend.id
            name: friend.name
            picture: friend.picture.data.url if @settings.showAvatars
          })

      return friends

    createSuggestionList: ->
      $suggestionList = $('<ul>').addClass('fbac-suggestion-list')
      $suggestionList.insertAfter(@element)
      return $suggestionList

    getCurrentSuggestions: (value) ->
      value = value.toLowerCase()
      suggestions = []
      index = 0
      while suggestions.length < @settings.maxSuggestions and index < @friends.length
        suggestions.push(@friends[index]) if @friends[index].name.toLowerCase().contains(value)
        index++

      return suggestions

    generateSuggestion: (suggestion) ->
      $suggestion = $('<li>').addClass('fbac-suggestion').data('uid', suggestion.id)
      $name = $('<span>').addClass('fbac-suggestion-name').text(suggestion.name)
      if @settings.showAvatars
        $avatar = $('<img>').addClass('fbac-suggestion-avatar').attr('src', suggestion.picture)
        $avatar.appendTo($suggestion)
      $name.appendTo($suggestion)

      return $suggestion

    filter: (value) ->
      suggestions = @getCurrentSuggestions(value)
      @list.empty()
      @list.append(@generateSuggestion(suggestion)) for suggestion in suggestions
      @currentPick = @list.children('.fbac-suggestion:first').addClass('fbac-current-pick')

    pickChange: (dir) ->
      $target = @currentPick[if dir == 'down' then 'next' else 'prev']('.fbac-suggestion')
      if $target.length > 0
        @currentPick.removeClass('fbac-current-pick')
        @currentPick = $target.addClass('fbac-current-pick')

    submit: ->
      @settings.onpick(@currentPick.data('uid'))
      @element.off('keyup.fbac')
      @list.remove()

  $.fn[pluginName] = (options) ->
    @each ->
      if !$.data(@, "plugin_#{pluginName}")
        $.data(@, "plugin_#{pluginName}", new Plugin(@, options))