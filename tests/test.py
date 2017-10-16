#!/usr/bin/python

import time

import ConfigReader
from utils import DBUtils


def getCurTime():
	timeInSec = int(time.time())
	print 'timeInSec: '+str(timeInSec)
	return timeInSec


def testSetup():
	updateQuery = 'UPDATE welcome_calls SET status=4,agent_id=100 where id=2'
	DBUtils.executeUpdateQuery(updateQuery)


def testSelectQuery():
	role = ConfigReader.getValue('db', 'role')
	filterAgentsQuery = 'SELECT user_id, role_id FROM bima_user_role_permission WHERE user_id < 0 and role_id = '+role+' limit 10'

	res = DBUtils.executeSelectQuery(filterAgentsQuery)

	print 'Result is None for '+filterAgentsQuery
	if res is None:
		pass

	print 'Zero results found for '+filterAgentsQuery
	if ( len(res) == 0):
		pass

	print 'res: '
	for row in res:
		print 'user_id - '+ str(row[0]) +', role_id - '+ str(row[1])

def testGetRemCountForAgent():
	res = main.getRemCountForAgent(1, 20, 123)
	for row in res:
		print row

def testSetRemWelCalToAgent():
	agentId=1
	rem=1
	allocatingStatus=3
	main.setRemWelCalToAgent(agentId, rem, allocatingStatus)

def insertWelcomeCalls(count):
	total = 0 
	user_id=3210
	agent_id=0
	status=1
	partner_country_id=111
	created_by=1010
	created_date='NOW()'
	policy_id=3333

	valStr = ''
	while (total < count):
		user_id = user_id + total
		valStr = valStr + '('+str(user_id)+','+str(agent_id)+','+str(status)+','+str(partner_country_id)+','+str(created_by)+','+str(created_date)+','+str(policy_id)+'),'
		total = total+1
	valStr = valStr[:-1]

	qry = 'INSERT INTO welcome_calls (user_id,agent_id,status,partner_country_id,created_by,created_date,policy_id) values '+valStr
	print 'insertWelcomeCalls qry: '+qry
	DBUtils.executeInsertQuery(qry)
	return

def testObj():
	d = ConfigReader.testObject()
	print d.width()
	print d.height()

def testCore(self):
	print ('In testCore.')
	print 'assignCount: '+str(self.__config.assignCount())
	return


# testObj()

# testSetup()

# getCurTime()

# testSetRemWelCalToAgent()

# testSelectQuery()

# main.makeValidWelCalQry()

# testGetRemCountForAgent()

# insertWelcomeCalls(1)

