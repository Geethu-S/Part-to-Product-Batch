@isTest
private class SyncPartsToProductsTest {
    @isTest
    static void testBatch() {
        // Create test data
        List<SQX_Part__c> parts = new List<SQX_Part__c>();
        parts.add(new SQX_Part__c(Name = 'Part 1', Part_Number__c = 'P001', Active__c = true));
        parts.add(new SQX_Part__c(Name = 'Part 2', Part_Number__c = 'P002', Active__c = true));
        insert parts;
        
        // Start batch
        Test.startTest();
        SyncPartsToProducts batch = new SyncPartsToProducts();
        Database.executeBatch(batch);
        Test.stopTest();
        
        // Verify results
        List<SQX_Part__c> updatedParts = [SELECT Id, Product__c FROM SQX_Part__c WHERE Id IN :parts];
        System.assertEquals(2, updatedParts.size());
        for(SQX_Part__c part : updatedParts) {
            System.assertNotEquals('null', part.Product__c);
        }
        
        List<Product2> products = [SELECT Id FROM Product2 WHERE Name IN ('Part 1', 'Part 2') AND ProductCode IN ('P001', 'P002')];
        System.assertEquals(2, products.size());
    }
}