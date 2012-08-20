global with sharing class LoggerRecycleBin {
	
	global static String CRON_STR = '0 0 * * * ?';
	
	global static void purge() {
		recycleNow(-1);//will delete all created before tomorrow
	}
	
	global static void recycleNow() {
		integer purgeAfterDays = LoggerSettings.getIntegerValue('PURGE_AFTER_DAYS');
		if (purgeAfterDays==null) purgeAfterDays=7;//default to 7 days
		recycleNow(purgeAfterDays);
	}
	
	global static void recycleNow(integer dayToRecycle) {
		LoggerRecycleBinBatch recycleLogs = new LoggerRecycleBinBatch();
		recycleLogs.query = getLogQuery(dayToRecycle);
		
		// Invoke the batch job.     
		ID batchprocessid = Database.executeBatch(recycleLogs, 1);
		System.debug('Returned batch process ID: ' + batchProcessId);
	}
	
	global static void schedule() {
		
		System.schedule('Logger Recycle Bin', CRON_STR, new LoggerRecycleBinSchedule());
	}
	
	public static string getLogQuery(integer dayToQuery) {
		Datetime d = Datetime.now();
		d = d.addDays(-dayToQuery);
		
		String query = 'SELECT Id, Body__c FROM Log__c WHERE CreatedDate < '+
			d.format('yyyy-MM-dd')+'T'+d.format('HH:mm')+':00.000Z';
			
		return query;
	}
}