public with sharing class LoggerSettings {

	public static string getValue(string key) {
		system.debug('getting value for key...' + key);
		
		LoggerSettings__c settingValue = LoggerSettings__c.getInstance(key);
		if (settingValue!= null && settingValue.Value__c!=null && settingValue.Value__c!='') {
			system.debug('returning value for key...' + key + '...value...' + settingValue.Value__c);
			return settingValue.Value__c;
		} else {
			system.debug('returning value for key...' + key + '...value...[null]');
			return null;
		}
	}
	public static integer getIntegerValue(string key) {
		string retVal = getValue(key);
		return (retVal!=null) ? integer.valueOf(retVal) : null;
	}
	public static boolean getBooleanValue(string key) {
		string retVal = getValue(key);
		return (retVal!=null && retVal.equals('TRUE'));
	}
}