trigger UpdateContactOwnerOnAccountChange on Account (after update) {
    // Execute only if the trigger context is "after update"
    if (Trigger.isUpdate && Trigger.isAfter) {
        // Map to store accounts with owner changes
        Map<Id, Id> accountOwnerChanges = new Map<Id, Id>();

        // Collect accounts where the OwnerId has changed
        for (Account acc : Trigger.New) {
            if (acc.OwnerId != Trigger.oldMap.get(acc.Id).OwnerId) {
                accountOwnerChanges.put(acc.Id, acc.OwnerId);
            }
        }

        // Proceed only if there are accounts with owner changes
        if (!accountOwnerChanges.isEmpty()) {
            // Query related contacts for these accounts
            List<Contact> contactsToUpdate = [
                SELECT Id, AccountId
                FROM Contact
                WHERE AccountId IN :accountOwnerChanges.keySet()
            ];

            // Update the OwnerId for related contacts
            for (Contact con : contactsToUpdate) {
                con.OwnerId = accountOwnerChanges.get(con.AccountId);
            }

            // Perform a bulk update
            if (!contactsToUpdate.isEmpty()) {
                update contactsToUpdate;
            }
        }
    }
}
