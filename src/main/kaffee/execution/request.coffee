# Copyright (c) 2012 Fabian M.
# See the AUTHORS file for all contributors of the Kaffee project.

###
  The {@link ExecutionRequest} class is a request to execute one or multiple goals.

  @version 0.3.0
  @author Fabian M. <mail.fabianm@gmail.com>
###
class ExecutionRequest

	###
	  Goals to be executed.
	###
	goals: {}
	
	###
	  Should be true if you force Kaffee, which is usually not a good thing.
	###
	force: false

	###
	  Constructs a new {@link ExecutionRequest}.

	  @since 0.2.1
	  @param goals The names of the goals to execute.
	  @param force Force Kaffee to do something.
	###
	constructor: (goals = [], force = false) -> 
		this.goals = goals
		this.force = force

	###
	  Adds a goal to this {@link ExecutionRequest}.

	  @since 0.2.1
	  @param goal The goal to add.
	###
	addGoal: (goal) ->
		return if not goal
		this.goals.push goal if typeof goal is 'string'
		this.goals.concat goal if typeof goal is 'array'

	###
	  Returns the goals of this {@link ExecutionRequest}.
	
	  @since 0.2.1
	  @return The goals of this {@link ExecutionRequest}.
	###
	getGoals: -> this.goals

	###
	  Sets the force field of this {@link ExecutionRequest}.

	  @since 0.2.1
	  @param force The force field to set.
	###
	setForce: (force) -> this.force = force if force

	###
	  Determines if Kaffee is forced or not.

	  @since 0.2.1
	  @return <code>true</code> if Kaffee is forced, <code>false</code> otherwise.
	###
	isForced: -> this.force
module.exports = ExecutionRequest
