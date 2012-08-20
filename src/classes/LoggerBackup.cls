public without sharing class LoggerBackup {
	
	private class callOutException extends Exception{}
	public boolean ENABLED;
	public string ENDPOINT;
	
	public LoggerBackup(){
		ENABLED = LoggerSettings.getBooleanValue('LOGGLY_ENABLED');
		ENDPOINT = LoggerSettings.getValue('LOGGLY_ENDPOINT');
		
		system.debug('LoggerBackup...ENABLED...' + ENABLED);
		system.debug('LoggerBackup...ENDPOINT...' + ENDPOINT);
	}
	
	public Boolean sendBackUp(String logBody) {
		if (!ENABLED) return true; //didnt happen but didnt need it backup anyway 
		
		HttpRequest req = getHttpRequest(logBody);
      	HttpResponse res = sendLog(req);
      	return handleResponse(res);
	}
	private HttpRequest getHttpRequest(String logBody) {
		// Instantiate a new HTTP request, specify the method (GET) as well as the endpoint 
	    HttpRequest req = new HttpRequest();
	    req.setEndpoint(ENDPOINT);
	    req.setHeader('Content-Type', 'text/plain');
	    req.setMethod('POST');
	    req.setBody(logBody);
	    
	    return req;
	}
	private HttpResponse sendLog(HttpRequest req) {
		//Instantiate a new http object  
		Http h = new Http();
		// Send the request, and return a response 
	    HttpResponse res = h.send(req);
	    
	    return res;
	}
	private Boolean handleResponse(HttpResponse res) {

	    if (Test.isRunningTest() || res.getStatusCode()==200) {
	    	return true;
	    } else {
	    	throw new callOutException('Error calling logging service: ' + res);
	    	return false;
	    }
	}
}