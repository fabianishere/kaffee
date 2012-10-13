Fs = require "fs"
Path = require "path"
###
  The {@link DefaultPlugin} class is the built-in Kaffee plugin and provides basic goals like "clean".

  @author Fabian M. <mail.fabianm@gmail.com>
###
class DefaultPlugin extends require("./plugin")

	###
	  Constructs a new {@link DefaultPlugin} instance.

	  @since 0.3.2
	  @param project The {@link Project} of this {@link Plugin}.
	  @param configuration The configuration of this {@link Plugin}.
	###
	constructor: (project, configuration = {}) ->
		super "kaffee-plugin", project, configuration
		@register "clean", ->
			structure = @getProject().getConfiguration().getKaffeeConfiguration().getStructure()
			@logger.info "Cleaning project #{ this.getProject().getConfiguration().getName() }"
			try
				remove = (path) ->
					return unless Fs.existsSync path
					for file in Fs.readdirSync path
						absolute = Path.join path, file
						stats = Fs.lstatSync absolute
						Fs.unlinkSync absolute if stats.isFile()
						remove absolute if stats.isDirectory()
					Fs.rmdirSync path
				remove structure.get("bin")
				remove structure.get("bin-test")
			catch e
				@logger.error e

	###
	  Loads this plugin.
	  
	  @since 0.3.0
	###
	load: -> # Do nothing.
module.exports = DefaultPlugin
