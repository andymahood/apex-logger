public with sharing class LoggerFactory {
	private static Map<String,Logger> loggers = new Map<String,Logger>();
	
	public static Logger getLogger() {
		return getLogger('Debug Log');
	}
	public static Logger getLogger(String name) {
		if (loggers.containsKey(name)) {
			return loggers.get(name);
		} else {
			System.debug('…\n…\n…\nCreating new logger for ' + name);
			Logger logger = new Logger(name);
			loggers.put(name, logger);
			return logger;
		}
	}
}