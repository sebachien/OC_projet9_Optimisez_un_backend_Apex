trigger UpdateAccountCATrigger on Order (before update, after update) {

    
    if(Trigger.isAfter) {
        set<Id> setAccountIds = new set<Id>();

        for(Order newOrder : Trigger.new){
            setAccountIds.add(newOrder.AccountId);
        }

        batchUpdateAccounts ba = new batchUpdateAccounts();
        ba.accountsToCheck = setAccountIds;

        Database.executeBatch(ba, 10);
    }
    
    if(Trigger.isBefore) {
        for (Order newOrder : Trigger.new) {
            newOrder.NetAmount__c = newOrder.TotalAmount - newOrder.ShipmentCost__c;
        }
    }
}
