Fs = require "fs"
Path = require "path"

Configuration = require "../configuration"
Util = require "../util"
###
  The {@link ProjectConfiguration} class contains configuration of the project.

  @author Fabian M. <mail.fabianm@gmail.com>
###
class ProjectConfiguration
	###
	  Constructs a new {@link ProjectConfiguration} instance.
	
	  @since 1.0
	  @param workspace The workspace of this {@link ProjectConfiguration} instance.
	  @param file The relative path to the project configuration file.
	###
	constructor: (@workspace, @file = Configuration.DEFAULT_PROJECT_CONFIG_FILE) ->
		@data = Configuration.SUPER_PROJECT_CONFIG
		@path = Path.join @getWorkspace().getPath(), @file
		@data = Util.merge @data, @read()

	###
	  Reads the package data file into a Javascript array.

	  @since 0.0.1
	###
	read: -> 
		try 
			return JSON.parse(Fs.readFileSync(@path, 'UTF-8')) 
		catch e 
			throw "Failed to load the project configuration file (#{ @path })\n#{ e }"
			

	###
	  Updates the package data file.

	  @param arr The array to update the package data file with.
	  @since 0.0.1
	###
	update: (arr = @data) -> Fs.writeFileSync(@path, JSON.stringify(arr))

	###
	  Returns the path to the file that contains the project data.

	  @since 0.1.1
	  @return The path to the file that contains the project data.	
	###
	getPath: -> @path

	###
	  Returns the {@link Workspace} of this {@link ProjectConfiguration} instance.

	  @since 0.3.0
	  @return The {@link Workspace} of this {@link ProjectConfiguration} instance.
	###
	getWorkspace: -> @workspace

	###
	  Returns the data that has been read.

	  @since 0.1.1
	  @return  The data that has been read.
	###
	getData: -> @data

	###
	  Returns the name of this package.

	  @since 0.3.0
	  @return The name of this package.
	###
	getName: -> @data.name

	###
	  Returns the version of this package.

	  @since 0.3.0
	  @return The version of this package.
	###
	getVersion: -> @data.version

	###
	  Returns the dependencies of this package.
	
	  @since 0.3.0
	  @return The dependencies of this package. 
	###
	getDependencies: -> @data.dependencies

	###
	  Returns the Kaffee configuration of this package.
	  The Kaffee configuration of this package should look something like:
	  	configuration:
	  		plugins:
	  			"compiler" :
	  				module: "kaffee-coffeemaker"
	  				alias: ["coffeescript", "coffee-script"]
	  			"minify" :
	  				module: "kaffee-minify"
	  			"automatic-build-1":
	  				module: "kaffee-cyclus"
	  				goals: ["compile"]
	  				every: "hour"
	  			"automatic-build-2":
	  				module: "kaffee-cyclus"
	  				goals: ["compile"]
	  				every: "change"
	  		archtype: "kaffee-archtype-simple"
	  		
	  @since 0.3.0
	  @return The Kaffee configuration of this package.
	###
	getKaffeeConfiguration: -> ((o) ->
		###
		  Kaffee configuration
		###
		data = o.data.kaffee
		
		###
	 	  Returns the plugins of this Kaffee project.

		  @since 0.3.0
		  @return The plugins of this Kaffee project.
		###
		@getPlugins = -> data.plugins

		###
	 	  Returns the directory structure of this Kaffee project.

		  @since 0.3.0
		  @return The directory structure of this Kaffee project.
		###
		@getStructure = -> 
			###
			  Returns this directory structure as an array.

			  @since 0.3.0
		 	  @return This directory structure as an array.
			###
			@toArray = -> data.structure

			###
			  Returns the path of the directory with the specified name.

			  @since 0.3.0
			  @return The path of the directory with the specified name.
			###
			@get = (name) ->
				Path.join o.getWorkspace().getPath(), @toArray()[name]
			this
		
		###
	 	  Returns the lifecycles of this Kaffee project.

		  @since 0.3.0
		  @return The lifecycles of this Kaffee project.
		###
		@getLifecycles = -> data.lifecycles
		
		###
		  Returns the parent project of this Kaffee project.
		  
		  @since 0.3.0
		  @return The parent project of this Kaffee project.
		###
		@getParent = -> data.parent
		
		###
		  Returns the childs of this Kaffee project.
		  
		  @since 0.3.0
		  @return The childs of this Kaffee project.
		###
		@getModules = -> data.modules
		
		###
		  Returns the archtype of this Kaffee project.
		  
		  @since 0.3.0
		  @return The archtype of this Kaffee project.
		###
		@getArchtype = -> data.archtype
	
		this
	) this

	###
	  Determines if the configuration file exists.

	  @since 0.0.1
	  @return <code>true</code> if the package.json exists, <code>false</code> otherwise.
	###
	exists: -> Fs.existsSync @path
module.exports = ProjectConfiguration
