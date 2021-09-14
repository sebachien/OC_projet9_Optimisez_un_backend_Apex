trigger UpdateAccountCA on Order (before update, after update) {

    
    if(Trigger.isAfter) {
        set<Id> setAccountIds = new set<Id>();

        for(Order newOrder : Trigger.new){
            setAccountIds.add(newOrder.AccountId);
        }

        UpdateAccounts ba = new UpdateAccounts();
        ba.accountsToCheck = setAccountIds;

        Database.executeBatch(ba, 100);
    }
    
    if(Trigger.isBefore) {
        for (Order newOrder : Trigger.new) {
            newOrder.NetAmount__c = newOrder.TotalAmount - newOrder.ShipmentCost__c;
        }
    }
}