Vue = require('vue')
{addModalPanel} = require('../utils')

module.exports = class SelectFile
  constructor: (files, onSelect, onCancel = -> ) ->
    vue = new Vue({
      template: """
        <div id="select-file" class="select-list fuzzy-finder">
          <div>Please choose which Ensime project to start up:</div>
          <ol class="list-group">
            <li v-for="file in files" v-bind:class="{'selected': $index==selected}">
              <div class="primary-line file icon icon-file-text">{{file}}</div>
            </li>
          </ol>
        </div>
        """
      data: () ->
        selected: 0
        files: files

      attached: () ->
        console.log("attached called")

        @done = () =>
          @commands.dispose()
          @$emit('done')

        @commands = atom.commands.add document,
          'core:move-up': (event) =>
            if(@selected > 0)
              @selected -= 1
            event.stopPropagation()

          'core:move-down': (event) =>
            if(@selected < files.length - 1)
              @selected += 1
            event.stopPropagation()

          'core:confirm': (event) =>
            selected = files[@selected]
            console.log("selected: " + selected)
            onSelect(selected)
            @done()
            event.stopPropagation()

          'core:cancel': (event) =>
            onCancel()
            @done()
            event.stopPropagation()
            
        console.log("attached finished: " + @$el)
      })

    @container = addModalPanel(vue, true)
    vue.$on 'done', () =>
      @container.destroy()

    vue.$el.focus()
