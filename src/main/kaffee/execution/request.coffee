###
  The {@link ExecutionRequest} class is a request to execute one or multiple goals.

  @author Fabian M. <mail.fabianm@gmail.com>
###
class ExecutionRequest
	###
	  Constructs a new {@link ExecutionRequest}.

	  @since 0.2.1
	  @param goals The names of the goals to execute.
	  @param force Force Kaffee to do something.
	###
	constructor: (@goals = [], @force = false) -> 
	
	###
	  Adds a goal to this {@link ExecutionRequest}.

	  @since 0.2.1
	  @param goal The goal to add.
	###
	addGoal: (goal) ->
		return if not goal
		@goals.push goal if typeof goal is 'string'
		@goals.concat goal if typeof goal is 'array'

	###
	  Returns the goals of this {@link ExecutionRequest}.
	
	  @since 0.2.1
	  @return The goals of this {@link ExecutionRequest}.
	###
	getGoals: -> @goals

	###
	  Sets the force field of this {@link ExecutionRequest}.

	  @since 0.2.1
	  @param force The force field to set.
	###
	setForce: (@force) -> 
	
	###
	  Determines if Kaffee is forced or not.

	  @since 0.2.1
	  @return <code>true</code> if Kaffee is forced, <code>false</code> otherwise.
	###
	isForced: -> @force
module.exports = ExecutionRequest
