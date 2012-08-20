@isTest
private class logger_TEST {
	
	static testMethod void testDefaultLogging() {
        Test.startTest();
        
		Logger defaultLog = LoggerFactory.getLogger();
		defaultLog.log('This is a default log ');
		
		//this will concatenate onto the default log
		Logger defaultLog2 = LoggerFactory.getLogger();
		defaultLog2.log('This is another on the default default log ');
		
		//both have same name
		system.assertEquals('Debug Log - ' + Userinfo.getUserName(), defaultLog.getLogName());
		system.assertEquals('Debug Log - ' + Userinfo.getUserName(), defaultLog2.getLogName());
		
		List<Log__c> logs = null;
		logs = [SELECT ID FROM Log__c];
		system.assertEquals(0,logs.size());//no logs committed yet
		
		defaultLog2.commitLog();
		
		logs = [SELECT ID FROM Log__c];
		system.assertEquals(1,logs.size());//one log committed
		
		LoggerRecycleBin.purge();//purge all logs
		
		Test.stopTest();

    }
    
    static testMethod void testCustomLogging() {
        Test.startTest();
        
		Logger log = LoggerFactory.getLogger('TESTLOG');
		log.log('This is a log ');
		
		system.assertEquals('TESTLOG - ' + Userinfo.getUserName(), log.getLogName());
		
		List<Log__c> logs = null;
		logs = [SELECT ID FROM Log__c];
		system.assertEquals(0,logs.size());//no logs committed yet
		
		log.commitLog();
		
		logs = [SELECT ID FROM Log__c];
		system.assertEquals(1,logs.size());//one log committed
		
		LoggerRecycleBin.purge();//purge all logs
		
		Test.stopTest();
		
		logs = [SELECT ID FROM Log__c];
		system.assertEquals(0,logs.size());//no logs committed 	

		
    }

    static testmethod void scheudleTest() {
		Test.startTest();
    	
	   	// Schedule the test job 
	    String jobId = System.schedule('LoggerRecycleBinSchedule', LoggerRecycleBin.CRON_STR, 
	         new LoggerRecycleBinSchedule());
	    
	    CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
	         NextFireTime
	         FROM CronTrigger WHERE id = :jobId];
	
	   	//Verify the expressions are the same 
	    System.assertEquals(LoggerRecycleBin.CRON_STR, ct.CronExpression);
	
	   	// Verify the job has not run 
	    System.assertEquals(0, ct.TimesTriggered);
	
	   	Test.stopTest();
	   	
   }
   
   
   static testmethod void loggerBackupTest() {
   		LoggerBackup backup = new LoggerBackup();
   		backup.ENABLED = true;
   		backup.ENDPOINT = '/xxx/';
   		
   		system.assertEquals(true, backup.sendBackUp('to log'));
   }
}