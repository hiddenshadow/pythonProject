#!/usr/bin/python

from utils import DBUtils

class Allocator:

	def __init__(self, config):
		self.__config = config

	# @property
	def config(self):
		return self.__config

	def getMultipleStatusQryStr(self, welCalStatusToPick):
		mulStatus = welCalStatusToPick.split(',')
		qry = ''
		for status in mulStatus:
			qry = qry+' status='+status+' or'
		qry = qry[:-3]
		return qry

	def makeValidWelCalQry(self,max,welCalStatusToPick):
		qry = 'SELECT id FROM welcome_calls WHERE '
		qry = qry + self.getMultipleStatusQryStr(welCalStatusToPick)
		qry = qry + ' limit '+str(max)
		# print qry
		return qry

	def getMaxValWelCal(self,max):
		# Get valid welcome_calls, where status=0 or status=4. [NEW, INCOMPLETE]
		validWelcomeCallsQuery = self.makeValidWelCalQry(max)
		valWelCal = DBUtils.executeSelectQuery(validWelcomeCallsQuery)
		return valWelCal

	def getRemCountForAgent(self,agentId, limit, pendStatus,host,user,password,database,port):
		qry = 'SELECT COUNT(*) FROM welcome_calls WHERE agent_id='+str(agentId)+' AND '+' status='+str(pendStatus)
		rem = DBUtils.executeSelectQuery(qry, host, user, password, database, port)
		# print 'rem='+str(rem)
		return (limit - int(rem[0][0]))

	def setRemWelCalToAgent(self,agentId, rem, allocatingStatus, welCalStatusToPick,host,user,password,database,port):
		qry = 'UPDATE welcome_calls SET agent_id='+str(agentId)+',status='+str(allocatingStatus)+' WHERE '
		qry = qry + self.getMultipleStatusQryStr(welCalStatusToPick)
		qry = qry + ' limit '+str(rem)
		print qry
		DBUtils.executeUpdateQuery(qry, host, user, password, database, port)
		return


	def getAgents(self,role,host,user,password,database,port):

		filterAgentsQuery = 'SELECT user_id, role_id FROM bima_user_role_permission WHERE user_id > 0 and role_id = '+role
		# print filterAgentsQuery

		validAgents = DBUtils.executeSelectQuery(filterAgentsQuery, host, user, password, database, port)
		return validAgents


	def allocate(self):
		print 'allocate()'
		try:
			configObj = self.__config

			allocatingStatus=configObj.allocatingStatus()
			assignlimit = configObj.assignCount()
			role = configObj.role()
			host= configObj.host()
			user= configObj.user()
			password= configObj.password()
			database= configObj.database()
			port= configObj.port()
			role= configObj.role()
			welCalStatusToPick = configObj.welCalStatusToPick()

			agents = self.getAgents(role,host,user,password,database,port)

			if len(agents) == 0:
				print 'No valid Agents found: '+agents
				return

			for agent in agents:
				print ''
				print 'agent - '+str(agent)
				agentId = agent[0]
				rem = (self.getRemCountForAgent(agentId,assignlimit,allocatingStatus,host,user,password,database,port))
				if rem > 0:
					print 'rem - '+str(rem)
					# In case no rows affected, we can check if there are any welcome calls remaining, else stop.
					self.setRemWelCalToAgent(agentId, rem, allocatingStatus, welCalStatusToPick,host,user,password,database,port)
				else:
					print 'No more assignment required for agent:'+str(agent)

		except Exception as e:
			print 'Exception while allocating'
			raise e
		finally:
			pass
		return
