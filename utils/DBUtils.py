#!/usr/bin/python

import mysql.connector

from utils.LogUtils import timeit
import logging


def getConnection(host,user,password,database,port):
	try:
		conn = mysql.connector.connect(user=user, password=password, host=host, database=database, port=port)
		if conn is None:
			raise Exception("Unable to connect to db.")
	except Exception as e:
		logging.error("Exception while getting DB connection: host="+host+", user="+user+", password="+password+", database="+database+", port="+port)
		raise e
	return conn


@timeit
def executeSelectQuery(query,host,user,password,database,port):
	conn=cursor=res=None
	try:
		conn = getConnection(host,user,password,database,port)
		cursor = conn.cursor()		
		cursor.execute(query)
		res = cursor.fetchall()
	except Exception, e:
		logging.error('Exception while executing Select Query: '+str(query))
		raise e
	finally:
		if cursor is not None :
			cursor.close()
		if conn is not None :
			conn.close()
		pass

	return res

@timeit
def executeUpdateQuery(query,host,user,password,database,port):
	try:
		conn = getConnection(host,user,password,database,port)
		cursor = conn.cursor()
		cursor.execute(query)
		conn.commit()
		logging.debug('Rows affected: '+str(cursor.rowcount)+', for query '+query)
		return cursor.rowcount
	except Exception, e:
		logging.error('Exception while executing Update Query: '+query+", host="+host+", user="+user+", password="+password+", database="+database+", port="+port)
	finally:
		if cursor is not None :
			cursor.close()
		if conn is not None :
			conn.close()
		pass
	return 0;

@timeit
def executeInsertQuery(query,host,user,password,database,port):
	return executeUpdateQuery(query,host,user,password,database,port)