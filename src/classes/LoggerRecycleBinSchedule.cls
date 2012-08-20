global class LoggerRecycleBinSchedule implements Schedulable {

   global void execute(SchedulableContext ctx) {
		LoggerRecycleBin.recycleNow();
   }   
}