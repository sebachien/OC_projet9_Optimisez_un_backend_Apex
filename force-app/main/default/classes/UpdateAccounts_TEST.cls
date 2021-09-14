@isTest
private class UpdateAccounts_TEST{
    @isTest static void BatchTest() {
        Account acc1 = new Account(Name = 'Test Account 1');
        insert acc1;

        Product2 pd1 = new Product2(Name = 'Chemise Verte longue XYX', Family = 'Chemise');
        insert pd1;
 
        //Create the PricebookEntry
        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = System.Test.getStandardPricebookId(),
            Product2Id = pd1.Id,
            UnitPrice = 1020,
            IsActive = true
        );
        insert pbe;

        date myDate = date.today();
        Contract ctt1 = new Contract(AccountId = acc1.Id, StartDate = myDate, ContractTerm = 1, Status='Draft');
        insert ctt1;
        
        Contract ctt2 = new Contract(Id = ctt1.Id, Status='Activated');
        update ctt2;

        Order o1 = new Order(AccountId = acc1.Id, ContractId = ctt2.Id,Status = 'Draft', EffectiveDate = date.today(), Pricebook2Id = System.Test.getStandardPricebookId(), ShipmentCost__c = 10);
        insert o1;

        OrderItem oi1 = new OrderItem (OrderId = o1.Id, PricebookEntryId = pbe.Id, Quantity=10, UnitPrice = 150);
        insert oi1;
        OrderItem oi2 = new OrderItem (OrderId = o1.Id, PricebookEntryId = pbe.Id, Quantity=20, UnitPrice = 1000);
        insert oi2;

        o1.Status = 'Ordered';
        
        Test.startTest();
        update o1;
        Test.stopTest();

        acc1 = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id = :acc1.Id];
        o1 = [SELECT Id, NetAmount__c FROM Order WHERE Id = :o1.Id];
        
        System.assertEquals(((10*150)+(20*1000)), acc1.Chiffre_d_affaire__c);
        System.assertEquals(((10*150)+(20*1000)-10), o1.NetAmount__c);
    }
}
