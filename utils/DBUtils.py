#!/usr/bin/python

import mysql.connector

from utils.LogUtils import timeit


@timeit
def getConnection(host,user,password,database,port):
	try:
		conn = mysql.connector.connect(user=user, password=password, host=host, database=database, port=port)
		if conn is None:
			raise Exception("Unable to connect to db.")
	except Exception as e:
		raise e
	return conn

# def executeInsertQuery(query):
# 	try:
# 		pass
# 	except Exception as e:
# 		raise e
# 	finally:
# 		pass
# 	return


@timeit
def executeSelectQuery(query,host,user,password,database,port):
	try:
		conn = getConnection(host,user,password,database,port)
		cursor = conn.cursor()		
		cursor.execute(query)
		res = cursor.fetchall()
	except Exception, e:
		print 'Exception while executing Select Query: '+str(query)
	finally:
		cursor.close()
		conn.close()					
	return res

@timeit
def executeUpdateQuery(query,host,user,password,database,port):
	try:
		conn = getConnection(host,user,password,database,port)
		cursor = conn.cursor(buffered=True)
		cursor.execute(query)
		conn.commit()
		# print 'Rows affected: '+str(cursor.rowcount)
	except Exception, e:
		print 'Exception while executing Update Query: '+query
	finally:
		cursor.close()
		conn.close()				
	return

@timeit
def executeInsertQuery(query,host,user,password,database,port):
	return executeUpdateQuery(query,host,user,password,database,port)