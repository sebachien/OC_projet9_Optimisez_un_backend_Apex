global class SchedulableUbdateAccount implements Schedulable { 
    set<Id> setAccountIds = new set<Id>();
    public static String sch = '0 0 6 ? * MON';//Tout les Lundi à 6h00

    global static String scheduleMe() {
        SchedulableUbdateAccount SC = new SchedulableUbdateAccount();
        return System.schedule('SchedulableUbdateAccount', sch, SC);
    }

    global void execute(SchedulableContext sc) {
        batchUpdateAccounts ba = new batchUpdateAccounts();
        ba.accountsToCheck = setAccountIds;
        Database.executeBatch(ba, 50);
    }
 }