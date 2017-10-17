#!/usr/bin/python

class Config:

    def __init__(self, host,user,password,database,port,assignCount,role,customerTable,roleTable,welCalStatusToPick,allocatingStatus,logConfigFile,appName):
        self.__host = host
        self.__user = user
        self.__password = password
        self.__database = database
        self.__port = port
        self.__assignCount = assignCount
        self.__role = role
        self.__customerTable = customerTable
        self.__roleTable = roleTable
        self.__welCalStatusToPick = welCalStatusToPick
        self.__allocatingStatus = allocatingStatus
        self.__logConfigFile = logConfigFile
        self.__appName = appName

        # self.__errorLogFile = errorLogFile
        # self.__infoLogFile = infoLogFile

    # @property
    def host(self):
        return self.__host

    # @property
    def user(self):
        return self.__user

    # @property
    def password(self):
        return self.__password

    # @property
    def database(self):
        return self.__database

    # @property
    def port(self):
        return self.__port

    # @property
    def assignCount(self):
        return self.__assignCount

    # @property
    def role(self):
        return self.__role

    # @property
    def customerTable(self):
        return self.__customerTable

    # @property
    def roleTable(self):
        return self.__roleTable

    # @property
    def welCalStatusToPick(self):
        return self.__welCalStatusToPick

    # @property
    def allocatingStatus(self):
        return self.__allocatingStatus

    # @property
    def logConfigFile(self):
        return self.__logConfigFile

    # @property
    def appName(self):
        return self.__appName