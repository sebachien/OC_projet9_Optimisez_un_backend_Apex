public class MyTeamOrdersController {

    public decimal SumOders {
        get{
            Id userId = UserInfo.getUserId();
             //First query the AccountTeamMember records
            List<AccountTeamMember> members = [SELECT Id, AccountId FROM AccountTeamMember WHERE UserId = :userId];
            //now get the Ids of all the accounts
            Set<Id> accountIds = new Set<Id>();
            for(AccountTeamMember member : members){
                accountIds.add(member.AccountId);
            }
            //calculate the sum of the totalAmount for the user's team online
            List<Account> acc = [SELECT Id FROM Account WHERE Id IN :accountIds OR OwnerId = :userId];
            AggregateResult groupedResults = [SELECT SUM(TotalAmount) total FROM Order WHERE AccountId IN :acc];
            return (decimal)groupedResults.get('total');
        }
        set;
    }
}
