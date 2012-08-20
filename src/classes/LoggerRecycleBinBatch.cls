global class LoggerRecycleBinBatch implements  Database.Batchable<sObject>, Database.AllowsCallouts {
	public String query;

	global Database.QueryLocator start(Database.BatchableContext BC){
		if (query==null)  query = LoggerRecycleBin.getLogQuery(-1);
		return Database.getQueryLocator(query);
	}

	global void execute(Database.BatchableContext BC, List<sObject> scope){
		Log__c log = (Log__c)scope[0];
      	Boolean safeToDelete=false;//can the delete be processed

	    LoggerBackup logBackup = new LoggerBackup();
  		safeToDelete = logBackup.sendBackUp(log.Body__c);
	
		/*
		safeToDelete means the backup was successful
		or loggly backup disabled
		*/
		if (safeToDelete) {
			delete scope;
			DataBase.emptyRecycleBin(scope);
		}
	}

	global void finish(Database.BatchableContext BC){
   	
	}
}