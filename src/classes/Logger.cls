global without sharing class Logger {

	private String logName;
	private String logBody;

	global Logger(string logName) {
		this.logName = logName + ' - ' + Userinfo.getUserName();
		this.logBody = '';
		
		log('********** ' + logName + ' **********');
		log('ORG: ' + Userinfo.getOrganizationName() + '[' + Userinfo.getOrganizationId() + ']');
		log('USER: ' + Userinfo.getUserName() + '[' + Userinfo.getUserId() + ']');
	}

	/*
	writes a line into the log with date stamp
	*/
	global void log(String message) {
		system.debug(message);
		logBody = logBody + '\n' + system.now().format() + ': ' + message;
	}

	/*
	persists log to database, additional method will hang off this
	eg. send log to loggr/loggly
	*/
	global void commitLog() {
		try {
			Log__c log = buildLog();
			
			insert log;			
			logBody='';
		} catch (Exception e) {
			system.debug('Failed to commit logs: ' + e);
		}
	}
	
	global string getLogName() {
		return logName;
	}
	
	/*
	creates the Log__c object to be persisted in databasedotcom
	*/
	private Log__c buildLog() {
		Log__c log = new Log__c();
		if (logBody.length() > 32000) {
			logBody = logBody.substring(0, 31999);
		}
		log.Body__c = logBody;
		log.Name = logName;
		return log;
	}
}