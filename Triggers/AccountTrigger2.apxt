trigger AccountTrigger on Account (before delete) {
    // Condition to check that the code should run only before the account is being deleted
    if(Trigger.isBefore && Trigger.isDelete) {
        // List of accounts with associated Contacts
        Map<Id, Account> mapOfAccounts = new Map<Id, Account> ([Select Id, (Select Id From Contacts) 
                                                                From Account 
                                                                Where Id IN :Trigger.oldMap.keySet()]);

        // Condition to check if any Contact is associated for each account
        // If yes, then throw the error
        for(Account acc : Trigger.old) {
            if(!mapOfAccounts.get(acc.Id).Contacts.isEmpty()) {
                acc.addError('Account with associated Contact(s) can not be deleted.');
            }
        }
    }
}