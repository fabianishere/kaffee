# Copyright (c) 2012 Fabian M.
# See the AUTHORS file for all contributors of the Kaffee project.
ProjectConfiguration = require './configuration'
Workspace = require './workspace'
Plugin = require '../plugin/plugin'
EventManager = require '../event/manager'
Result = require '../execution/result'
Request = require '../execution/request'
Configuration = require '../configuration'
###
  The {@link Project} class represents a Kaffee project.

  @version 0.1.1
  @author Fabian M. <mail.fabianm@gmail.com>
###
class Project
	
	###
	  The {@link Plugin}s of this {@link Project} instance.
	###
	plugins: []

	###
	  The parent {@link Project} of this {@link Project}.
	###
	parent: null

	###
	  The child {@link Project}s of this {@link Project}.
	###
	childs: []

	###
	  The {@link ProjectConfiguration} of this {@link Project}.
	###
	configuration: null

	###
	  The {@link EventManager} of this {@link Project}.
	###
	event: null

	###
	  Constructs a new {@link Project} instance.
	
	  @since 0.0.1
	  @param configuration The {@link ProjectConfiguration} of this project.
	  @param parent The parent {@link Project} of this {@link Project}.
	###
	constructor: (configuration, parent = null) ->	
		this.plugins = []
		this.childs = []
		
		this.event = new EventManager "project", null, this
		this.event.setParent parent.getEventManager() if parent
		this.parent = parent
		this.configuration = configuration
		this.event.setName "project-" + this.configuration.getName()
		
	###
	  Returns the parent {@link Project} instance.
	  
	  @since 0.3.0
	  @return The parent {@link Project} instance.
	###
	getParent: -> this.parent

	###
	  Loads this {@link Project}.

	  @since 0.2.1
	###
	load: ->
		this.event.fire "enter", this
		try
			for child in this.configuration.getKaffeeConfiguration().getModules()
				continue if typeof child != 'string'
				workspace = new Workspace child
				continue if workspace.getPath() == this.configuration.getWorkspace().getPath()
				project = new Project(new ProjectConfiguration(workspace), this)
				project.load()
				this.addChild project
			for name, configuration of this.configuration.getKaffeeConfiguration().getPlugins()
					plugin = new Plugin name, this, configuration
					return if !plugin.load()
					this.plugins.push plugin 
		catch e
			this.event.getLogger().error e
			return
		this.event.fire "leave", this
		true

	###
	  Returns the {@link EventManager} of this {@link Project}.

	  @since 0.3.0
	  @return The {@link EventManager} of this {@link Project}.
	###
	getEventManager: -> this.event

	###
	  Returns the {@link ProjectConfiguration} of this {@link Project}.

	  @since 0.2.1
	  @return The {@link ProjectConfiguration} of this {@link Project}.
	###
	getConfiguration: -> this.configuration

	###
	  Returns the {@link Plugin}s of this {@link Project}.
	  @since 0.2.1
	  @return The {@link Plugin}s of this {@link Project}.
	###
	getPlugins: -> if this.getParent() then this.plugins.concat this.getParent().getPlugins() else this.plugins
		
	###
	  Returns a {@link Plugin} of this {@link Project}.
	  
	  @since 0.3.0
	  @param name The name of the {@link Plugin} to get.
	  @return The {@link Plugin}.
	###
	getPlugin: (name) ->
		for plugin in this.getPlugins()
			return plugin if plugin.getName() == name
			
	###
	  Determines if this {@link Plugin} has a {@link Goal}.
	
	  @since 0.2.1
	  @param name The name of the {@link Plugin}.
	###
	hasPlugin: (name) -> !!this.getPlugin name
	
	###
	  Returns the lifecycles of this {@link Plugin}.
	  
	  @since 0.3.0
	  @return The lifecycles of this {@link Plugin}.
	###
	getLifecycles: -> 
		c = {}
		# Copy object
		c[key] = value for key, value of this.getParent().getLifecycles() if this.getParent()
		for key, value of this.getConfiguration().getKaffeeConfiguration().getLifecycles()
			c[key] = value
		c
			
			
		
	###
	  Returns the child {@link Project}s of this {@link Project}.

	  @since 0.3.0
	  @return The child {@link Project}s of this {@link Project}.
	###
	getChilds: -> this.childs

	###
	  Adds a child {@link Project} to this {@link Project}.

	  @since 0.3.0
	  @param project The {@link Project} to add.
	###
	addChild: (child) ->
		return this.childs = this.childs.concat child if typeof child == 'array'
		return this.childs.push child if child

	###
	  Executes a {@link ExecutionRequest}.

	  @since 0.1.1
	  @param request The {@link ExecutionRequest} instance.
	  @return The {@link ExecutionResult} instance.
	###
	execute: (request) ->
		try 
			for goal in request.getGoals()
				this.attainGoal goal
			for child in this.childs
				child.execute request
		catch e
			this.event.getLogger().error e
			return
	
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
			if not this.hasPlugin plugin
				this.event.getLogger().error "No such plugin \"#{ plugin }\""
				return
			if not this.getPlugin(plugin).hasGoal goal
				this.event.getLogger().error "Plugin #{ plugin } doesn't have goal \"#{ goal }\""
				return
			return this.getPlugin(plugin).getGoal(goal).attain request
		lifecycle = this.getLifecycles()[name]
		if not lifecycle
			this.event.getLogger().error "Unknown lifecycle \"#{ name }\""
			return
		this.attainGoal goal if goal != name for goal in lifecycle

module.exports = Project	
