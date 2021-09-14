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
            List<Account> acc = [SELECT Id FROM Account WHERE Id IN :accountIds OR OwnerId = :userId];
            AggregateResult groupedResults = [SELECT SUM(TotalAmount) total FROM Order WHERE AccountId IN :acc];
            return (decimal)groupedResults.get('total');
        }
        set;
    }
}

//active les team sur salesforce 
// sur page account (afficher team)
// somme de tout les order de ma team 
