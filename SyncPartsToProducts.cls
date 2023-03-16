global class SyncPartsToProducts implements Database.Batchable < SObject > {
    public Database.QueryLocator start(Database.BatchableContext bc){
        String query = 'SELECT Id, Name, Part_Number__c, Product__c FROM SQX_Part__c WHERE Product__c = NULL AND Active__c = true ';
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext bc, List<SQX_Part__c> ctx) {
        
        List<Product2> productsToCreate = new List<Product2>();
        
        for(SQX_Part__c part : ctx) {
            // Search for product with same name and product code as part
            List<Product2> products = [SELECT Id FROM Product2 WHERE Name = :part.Name AND ProductCode = :part.Part_Number__c];
            
            if(products.isEmpty()) {
                // Create new product with mapping details
                Product2 product = new Product2(Name = part.Name, ProductCode = part.Part_Number__c, IsActive = true);
                productsToCreate.add(product);
                part.Product__c = product.Id;
            } else {
                // Update part with existing product reference
                part.Product__c = products[0].Id;
            }
        }
           // Insert new products
        if(!productsToCreate.isEmpty()) {
            insert productsToCreate;
        }
        
        // Update parts
        update ctx;
     
        
    }
     global void finish(Database.BatchableContext BC) {
        system.debug('Records  Updated Successfully ');
        
    }
        
    //public void executeBatch() {
    //if(!UserInfo.getProfileId().equals('CQ_Product_Admin') )&& (!PermissionHelper.hasSysAdminPermission()) {
        //    throw new CustomException('You are not authorized to execute this batch class');
      // }
   // }
}