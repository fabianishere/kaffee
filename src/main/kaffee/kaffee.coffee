###
  Kaffee
  A software project management tool that adds more flavor to your application.

  @author Fabian M. <mail.fabianm@gmail.com>
###
module.exports = 
	Configuration: require('./configuration')
	project: 
		Project: require('./project/project')
		ProjectConfiguration: require('./project/configuration')
		Workspace: require('./project/workspace')
	event:
		EventManager: require('./event/manager')
		LogEvent: require('./event/logevent')
	execution:
		Request: require('./execution/request'),
		Result: require('./execution/result')
	plugin:
		Plugin: require('./plugin/plugin'),
		Goal: require('./plugin/goal')

