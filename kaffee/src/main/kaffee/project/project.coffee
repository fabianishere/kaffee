ProjectConfiguration = require "./configuration"
Workspace = require "./workspace"
Plugin = require "../plugin/plugin"
EventManager = require "../event/manager"
Result = require "../execution/result"
Request = require "../execution/request"
Configuration = require "../configuration"
Util = require "../util"

###
  The {@link Project} class represents a Kaffee project.

  @author Fabian M. <mail.fabianm@gmail.com>
###
class Project

	###
	  Constructs a new {@link Project} instance.
	
	  @since 0.0.1
	  @param configuration The {@link ProjectConfiguration} of this project.
	  @param parent The parent {@link Project} of this {@link Project}.
	###
	constructor: (@configuration, @parent) ->	
		@plugins = []
		@childs = []
		
		@event = new EventManager "project", null, this
		@event.setParent parent?.getEventManager()
		@event.setName "project-" + @configuration.getName()
		
	###
	  Returns the parent {@link Project} instance.
	  
	  @since 0.3.0
	  @return The parent {@link Project} instance.
	###
	getParent: -> @parent

	###
	  Loads this {@link Project}.

	  @since 0.2.1
	###
	load: ->
		@event.fire "enter", this
		try
			for child in @configuration.getKaffeeConfiguration().getModules()
				continue if typeof child isnt 'string'
				workspace = new Workspace child
				continue if workspace.getPath() is @configuration.getWorkspace().getPath()
				project = new Project new ProjectConfiguration(workspace), this
				project.load()
				@childs.push project
			# Add the `kaffee-plugin` to this project.
			@plugins.push new (require "../plugin/default")(this)
			
			for name, configuration of @configuration.getKaffeeConfiguration().getPlugins()
					plugin = new Plugin name, this, configuration
					return unless plugin.load()
					@plugins.push plugin
					
			archtype = @configuration.getKaffeeConfiguration().getArchtype()
			plugin = @getPlugin archtype
			if plugin and plugin.hasArchtype()
				@configuration.data = Util.merge plugin.getArchtype(), @configuration.data
			else if archtype # Archtype is given, but it doesn't exists.
				throw "Invalid archtype \"#{ archtype }\""
		catch e
			@event.getLogger().error e
			return
		@event.fire "leave", this
		true

	###
	  Returns the {@link EventManager} of this {@link Project}.

	  @since 0.3.0
	  @return The {@link EventManager} of this {@link Project}.
	###
	getEventManager: -> @event

	###
	  Returns the {@link ProjectConfiguration} of this {@link Project}.

	  @since 0.2.1
	  @return The {@link ProjectConfiguration} of this {@link Project}.
	###
	getConfiguration: -> @configuration

	###
	  Returns the {@link Plugin}s of this {@link Project}.
	  @since 0.2.1
	  @return The {@link Plugin}s of this {@link Project}.
	###
	getPlugins: -> if @getParent() then @plugins.concat @getParent().getPlugins() else @plugins
		
	###
	  Returns a {@link Plugin} of this {@link Project}.
	  
	  @since 0.3.0
	  @param name The name of the {@link Plugin} to get.
	  @return The {@link Plugin}.
	###
	getPlugin: (name) -> 
		return plugin for plugin in @getPlugins() when plugin.getName() is name or plugin.getAliases().indexOf(name) isnt -1
			
	###
	  Determines if this {@link Plugin} has a {@link Goal}.
	
	  @since 0.2.1
	  @param name The name of the {@link Plugin}.
	###
	hasPlugin: (name) -> !!@getPlugin name
	
	###
	  Returns the lifecycles of this {@link Plugin}.
	  
	  @since 0.3.0
	  @return The lifecycles of this {@link Plugin}.
	###
	getLifecycles: -> 
		c = @getParent()?.getLifecycles()?.slice(0)
		c or= []
		for key, value of @getConfiguration().getKaffeeConfiguration().getLifecycles()
			c[key] = value
		c
	###
	  Returns the child {@link Project}s of this {@link Project}.

	  @since 0.3.0
	  @return The child {@link Project}s of this {@link Project}.
	###
	getChilds: -> @childs

	###
	  Executes a {@link ExecutionRequest}.

	  @since 0.1.1
	  @param request The {@link ExecutionRequest} instance.
	  @return The {@link ExecutionResult} instance.
	###
	execute: (request) ->
		request.time = Date.now()
		result = new Result this
		try 
			result.addChild @attainGoal(goal) for goal in request.getGoals()
			result.addChild child.execute(request) for child in @childs
		catch e
			@event.getLogger().error e
			return
		result.time = Date.now()
		result
	
	###
	  Attains a {@link Goal}.
	  
	  @since 0.3.0
	  @param name The name of the goal to execute.
	  @param request The {@link ExecutionRequest} instance.
	  @return The result 
	###
	attainGoal: (name, request) ->
		return if not name
		if name.split(':').length > 1
			split = name.split(':')
			plugin = split[0]
			goal = split[1]
			if not @hasPlugin plugin
				@event.getLogger().error "No such plugin \"#{ plugin }\""
				return
			if not @getPlugin(plugin).hasGoal goal
				@event.getLogger().error "Plugin #{ plugin } doesn't have goal \"#{ goal }\""
				return
			return @getPlugin(plugin).getGoal(goal).attain request
		lifecycle = @getLifecycles()[name]
		if not lifecycle
			@event.getLogger().error "Unknown lifecycle \"#{ name }\""
			return
		@attainGoal goal for goal in lifecycle when goal isnt name

module.exports = Project	
